import 'package:flutter/material.dart';
import 'package:materialgramclient/core/models/attachment.dart';

/// Виджет поля ввода сообщения с поддержкой вложений
class ChatInputField extends StatelessWidget {
  final TextEditingController textController;
  final List<Attachment> attachments;
  final VoidCallback onAttachmentAdded;
  final VoidCallback onSendMessage;
  final Function(int) onAttachmentRemoved;

  const ChatInputField({
    super.key,
    required this.textController,
    required this.attachments,
    required this.onAttachmentAdded,
    required this.onSendMessage,
    required this.onAttachmentRemoved,
  });

  @override
  Widget build(BuildContext context) {
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
          // Область предпросмотра вложений
          if (attachments.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: attachments.length,
                itemBuilder: (context, index) {
                  final attachment = attachments[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.surfaceContainerHighest,
                          ),
                          child: attachment.type == 'image'
                              ? Icon(Icons.image, color: colorScheme.onSurfaceVariant)
                              : Icon(Icons.insert_drive_file, color: colorScheme.onSurfaceVariant),
                        ),
                        // Кнопка удаления вложения
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => onAttachmentRemoved(index),
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
          if (attachments.isNotEmpty) const SizedBox(height: 12),
          // Основная строка ввода
          Row(
            children: [
              // Кнопка эмодзи (TODO: Реализовать выбор эмодзи)
              IconButton(
                icon: Icon(Icons.emoji_emotions, color: colorScheme.onSurfaceVariant),
                onPressed: () {},
                tooltip: 'Эмодзи',
              ),
              // Текстовое поле
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
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: 'Введите сообщение...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                          maxLines: null, // Многострочный ввод
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => onSendMessage(), // Отправка по Enter
                        ),
                      ),
                      // Кнопка прикрепления файла
                      IconButton(
                        icon: Icon(Icons.attach_file, color: colorScheme.onSurfaceVariant),
                        onPressed: onAttachmentAdded,
                        tooltip: 'Прикрепить файл',
                      ),
                      // Кнопка камеры (TODO: Реализовать съемку фото)
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
              // Кнопка отправки
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: textController.text.isNotEmpty || attachments.isNotEmpty
                      ? colorScheme.primary // Активный цвет
                      : colorScheme.surfaceContainerHighest, // Неактивный цвет
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: textController.text.isNotEmpty || attachments.isNotEmpty
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: onSendMessage,
                  tooltip: 'Отправить',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}