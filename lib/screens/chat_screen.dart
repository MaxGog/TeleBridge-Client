import 'package:flutter/material.dart';
import 'package:materialgramclient/models/attachment.dart';
import 'package:materialgramclient/models/message.dart';
import 'package:materialgramclient/widgets/message_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final List<Attachment> _attachments = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Заглушка сообщений
    _messages.addAll([
      Message(
        text: 'Привет! Как дела?',
        isMe: false,
        time: '12:30',
        attachments: [],
      ),
      Message(
        text: 'Всё отлично! Как твои успехи с Flutter?',
        isMe: true,
        time: '12:31',
        attachments: [],
      ),
      Message(
        text: 'Отлично! Material 3 выглядит потрясающе 😊',
        isMe: false,
        time: '12:32',
        attachments: [],
      ),
    ]);
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty || _attachments.isNotEmpty) {
      setState(() {
        _messages.insert(0, Message(
          text: _textController.text,
          isMe: true,
          time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          attachments: List.from(_attachments),
        ));
        _textController.clear();
        _attachments.clear();
      });
      
      // Прокрутка к новому сообщению
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _addAttachment() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Добавить вложение',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.photo,
                  label: 'Фото',
                  onTap: () {
                    setState(() {
                      _attachments.add(Attachment(type: 'image', content: 'assets/avatars/default.png'));
                    });
                    Navigator.pop(context);
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Документ',
                  onTap: () {
                    setState(() {
                      _attachments.add(Attachment(type: 'document', content: 'document.pdf'));
                    });
                    Navigator.pop(context);
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.mic,
                  label: 'Аудио',
                  onTap: () {
                    setState(() {
                      _attachments.add(Attachment(type: 'audio', content: 'audio.mp3'));
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({required IconData icon, required String label, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onTap,
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            padding: const EdgeInsets.all(16),
          ),
          iconSize: 28,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.person,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Имя чата',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'в сети',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1,
        scrolledUnderElevation: 3,
        actions: [
          IconButton(
            icon: Icon(Icons.videocam, color: colorScheme.onSurface),
            onPressed: () {},
            tooltip: 'Видеозвонок',
          ),
          IconButton(
            icon: Icon(Icons.call, color: colorScheme.onSurface),
            onPressed: () {},
            tooltip: 'Голосовой звонок',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {},
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            surfaceTintColor: colorScheme.surface,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Настройки',
                  child: ListTile(
                    leading: Icon(Icons.settings, color: colorScheme.onSurface),
                    title: Text('Настройки чата'),
                  ),
                ),
                PopupMenuItem(
                  value: 'Информация',
                  child: ListTile(
                    leading: Icon(Icons.info, color: colorScheme.onSurface),
                    title: Text('Информация о чате'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.1),
              ),
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(
                    text: message.text,
                    isMe: message.isMe,
                    time: message.time,
                    attachments: message.attachments,
                  );
                },
              ),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_attachments.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _attachments.length,
                itemBuilder: (context, index) {
                  final attachment = _attachments[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.surfaceVariant,
                          ),
                          child: attachment.type == 'image'
                              ? Icon(Icons.image, color: colorScheme.onSurfaceVariant)
                              : Icon(Icons.insert_drive_file, color: colorScheme.onSurfaceVariant),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _attachments.removeAt(index);
                              });
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (_attachments.isNotEmpty) const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.emoji_emotions, color: colorScheme.onSurfaceVariant),
                onPressed: () {},
                tooltip: 'Эмодзи',
              ),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'Введите сообщение...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.attach_file, color: colorScheme.onSurfaceVariant),
                        onPressed: _addAttachment,
                        tooltip: 'Прикрепить файл',
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt, color: colorScheme.onSurfaceVariant),
                        onPressed: () {},
                        tooltip: 'Камера',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _textController.text.isNotEmpty || _attachments.isNotEmpty
                      ? colorScheme.primary
                      : colorScheme.surfaceVariant,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: _textController.text.isNotEmpty || _attachments.isNotEmpty
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: _sendMessage,
                  tooltip: 'Отправить',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}