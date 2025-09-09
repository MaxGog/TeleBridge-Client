import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:materialgramclient/screens/add_account_screen.dart';
import '../core/models/account.dart';
import '../core/models/chat_folder.dart';

/// Экран со списком чатов - основной интерфейс приложения
/// Отображает список чатов, панель управления аккаунтами и папками
class ChatListScreen extends StatelessWidget {
  final List<Account> accounts; // Список всех доступных аккаунтов
  final Account currentAccount; // Текущий выбранный аккаунт
  final Function(Account) onAccountChanged; // Колбэк для смены аккаунта
  final Function(Account) onAddAccount; // Колбэк для добавления аккаунта
  final List<ChatFolder> folders; // Список папок для организации чатов
  final String currentFolderId; // ID текущей выбранной папки
  final Function(String) onChangeFolder; // Колбэк для смены папки
  final Function(String) onAddFolder; // Колбэк для добавления папки

  const ChatListScreen({super.key, 
    required this.accounts,
    required this.currentAccount,
    required this.onAccountChanged,
    required this.onAddAccount,
    required this.folders,
    required this.currentFolderId,
    required this.onChangeFolder,
    required this.onAddFolder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MaterialGram',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 3,
        actions: [
          // Кнопка управления папками
          IconButton(
            icon: Icon(Icons.folder, color: colorScheme.onSurface),
            onPressed: () => Navigator.pushNamed(context, '/folders'),
            tooltip: 'Папки',
          ),
          // Кнопка настроек приложения
          IconButton(
            icon: Icon(Icons.settings, color: colorScheme.onSurface),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Настройки',
          ),
          // Кнопка добавления нового аккаунта
          IconButton(
            icon: Icon(Icons.add, color: colorScheme.onSurface),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAccountScreen(onAddAccount: onAddAccount),
              ),
            ),
            tooltip: 'Добавить аккаунт',
          ),
          // Выпадающее меню для выбора аккаунта (только если есть аккаунты)
          if (accounts.isNotEmpty)
            PopupMenuButton<Account>(
              onSelected: onAccountChanged, // Обработчик выбора аккаунта
              icon: Icon(Icons.account_circle, color: colorScheme.onSurface),
              itemBuilder: (BuildContext context) {
                return accounts.map((Account account) {
                  return PopupMenuItem<Account>(
                    value: account,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          account.name.isNotEmpty ? account.name[0].toUpperCase() : 'A',
                          style: TextStyle(color: colorScheme.onPrimaryContainer),
                        ),
                      ),
                      title: Text(
                        account.name,
                        style: textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        'Бот аккаунт',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }).toList();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Горизонтальный список папок для фильтрации чатов
          if (folders.isNotEmpty)
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.4),
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: folders.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  final isSelected = currentFolderId == folder.id; // Проверка выбранной папки
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                    child: FilterChip(
                      label: Text(
                        folder.name,
                        style: textTheme.labelLarge?.copyWith(
                          color: isSelected 
                            ? colorScheme.onPrimary 
                            : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          onChangeFolder(folder.id); // Смена текущей папки
                        }
                      },
                      backgroundColor: colorScheme.surface,
                      selectedColor: colorScheme.primary,
                      checkmarkColor: colorScheme.onPrimary,
                      side: BorderSide(
                        color: isSelected 
                          ? colorScheme.primary 
                          : colorScheme.outline.withOpacity(0.3),
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected 
                            ? colorScheme.primary 
                            : colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  );
                },
              ),
            ),
          
          // Основной список чатов
          Expanded(
            child: Material(
              color: colorScheme.surface,
              child: ListView.separated(
                itemCount: 20, // Заглушка - 20 тестовых чатов
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  indent: 72, // Отступ для выравнивания с аватарами
                  endIndent: 16,
                  color: colorScheme.outline.withOpacity(0.1),
                ),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    try {
                      // Навигация к экрану чата (заглушка)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text('Чат ${index + 1}'),
                              backgroundColor: colorScheme.surface,
                              foregroundColor: colorScheme.onSurface,
                            ),
                            body: Container(
                              color: colorScheme.surface,
                              child: Center(
                                child: Text(
                                  'Содержимое чата ${index + 1}',
                                  style: textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } catch (e) {
                      // Обработка ошибок навигации
                      if (kDebugMode) {
                        print('Ошибка навигации: $e');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Не удалось открыть чат'),
                          backgroundColor: colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    color: colorScheme.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        // Аватар чата
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primaryContainer,
                          ),
                          child: Icon(
                            Icons.person,
                            color: colorScheme.onPrimaryContainer,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Основная информация о чате
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Чат ${index + 1}', // Заглушка названия чата
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Последнее сообщение в чате ${index + 1}', // Заглушка последнего сообщения
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Блок с временем и статусом сообщения
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '12:${index % 60}'.padLeft(2, '0'), // Заглушка времени
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Индикатор статуса сообщения (только для каждого третьего чата)
                            if (index % 3 == 0)
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.primary,
                                ),
                                child: Icon(
                                  Icons.done,
                                  size: 12,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Плавающая кнопка для создания нового чата
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Реализовать функционал создания нового чата
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: const Icon(Icons.chat, size: 24),
      ),
    );
  }
}