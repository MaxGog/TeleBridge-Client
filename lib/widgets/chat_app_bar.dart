import 'package:flutter/material.dart';

/// Кастомный AppBar для экрана чата
/// TODO: Получить реальное имя чата и статус из Telegram
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onVideoCall;
  final VoidCallback onVoiceCall;

  const ChatAppBar({
    super.key,
    required this.onVideoCall,
    required this.onVoiceCall,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppBar(
      title: Row(
        children: [
          // Аватар чата
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
                'Имя чата', // TODO: Получить реальное имя чата из Telegram
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                'в сети', // TODO: Получить реальный статус из Telegram
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
        // Кнопка видеозвонка (недоступна для ботов)
        IconButton(
          icon: Icon(Icons.videocam, color: colorScheme.onSurface),
          onPressed: onVideoCall,
          tooltip: 'Видеозвонок',
        ),
        // Кнопка голосового звонка (недоступна для ботов)
        IconButton(
          icon: Icon(Icons.call, color: colorScheme.onSurface),
          onPressed: onVoiceCall,
          tooltip: 'Голосовой звонок',
        ),
        // Меню дополнительных опций
        PopupMenuButton<String>(
          onSelected: (value) {
            // TODO: Реализовать действия меню
          },
          icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
          surfaceTintColor: colorScheme.surface,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'Настройки',
                child: ListTile(
                  leading: Icon(Icons.settings, color: colorScheme.onSurface),
                  title: const Text('Настройки чата'),
                ),
              ),
              PopupMenuItem(
                value: 'Информация',
                child: ListTile(
                  leading: Icon(Icons.info, color: colorScheme.onSurface),
                  title: const Text('Информация о чате'),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}