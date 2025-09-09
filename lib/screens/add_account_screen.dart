import 'package:flutter/material.dart';
import '../core/models/account.dart';

/// Экран для добавления нового аккаунта Telegram бота
/// Позволяет пользователю ввести токен и имя для подключения бота
class AddAccountScreen extends StatefulWidget {
  final Function(Account) onAddAccount; // Колбэк для добавления аккаунта

  const AddAccountScreen({super.key, required this.onAddAccount});

  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>(); // Ключ для управления формой
  final _tokenController = TextEditingController(); // Контроллер для поля токена
  final _nameController = TextEditingController(); // Контроллер для поля имени
  bool _isLoading = false; // Флаг состояния загрузки

  /// Обработчик отправки формы
  /// Валидирует данные и создает новый аккаунт
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Включаем индикатор загрузки
      
      // Имитация загрузки для демонстрации (в реальном приложении здесь был бы API вызов)
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Создаем и передаем новый аккаунт через колбэк
      widget.onAddAccount(Account(
        token: _tokenController.text,
        name: _nameController.text,
      ));
      
      setState(() => _isLoading = false); // Выключаем индикатор загрузки
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить аккаунт'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок секции
            Text(
              'Подключение аккаунта',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            // Подзаголовок с описанием
            Text(
              'Введите данные для подключения вашего бота',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Форма ввода данных
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Поле для ввода имени аккаунта
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Имя аккаунта',
                      hintText: 'Мой телеграм бот',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
                    ),
                    style: TextStyle(color: colorScheme.onSurface),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Введите имя';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Поле для ввода токена бота
                  TextFormField(
                    controller: _tokenController,
                    decoration: InputDecoration(
                      labelText: 'Токен бота',
                      hintText: '123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
                    ),
                    obscureText: true, // Скрываем ввод для безопасности
                    style: TextStyle(color: colorScheme.onSurface),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Введите токен';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  // Подсказка о том, где получить токен
                  Text(
                    'Токен можно получить у @BotFather в Telegram',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Кнопка отправки формы
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _handleSubmit, // Блокируем кнопку при загрузке
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Добавить аккаунт',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // Информационная секция
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок информационного блока
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Информация',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Текст с пояснением
                  Text(
                    'Для работы приложения необходим токен бота, '
                    'который можно получить создав нового бота через @BotFather '
                    'в Telegram.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Очищаем контроллеры для предотвращения утечек памяти
    _tokenController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

/// ============================================================================
/// ЧТО НУЖНО ДОДЕЛАТЬ ДЛЯ ПОЛНОЙ ИНТЕГРАЦИИ С TELEGRAM:
/// ============================================================================

/// 1. ВАЛИДАЦИЯ ТОКЕНА В РЕАЛЬНОМ ВРЕМЕНИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить проверку токена через Telegram API перед добавлением аккаунта:
/// 
/// Future<bool> _validateBotToken(String token) async {
///   try {
///     final response = await http.get(
///       Uri.parse('https://api.telegram.org/bot$token/getMe'),
///     );
///     
///     if (response.statusCode == 200) {
///       final data = json.decode(response.body);
///       return data['ok'] == true;
///     }
///     return false;
///   } catch (e) {
///     return false;
///   }
/// }
/// 
/// // В методе _handleSubmit добавить проверку:
/// final isValid = await _validateBotToken(_tokenController.text);
/// if (!isValid) {
///   ScaffoldMessenger.of(context).showSnackBar(
///     SnackBar(content: Text('Неверный токен бота')),
///   );
///   return;
/// }
/// 

/// 2. АВТОМАТИЧЕСКОЕ ПОЛУЧЕНИЕ ИМЕНИ БОТА
/// ----------------------------------------------------------------------------
/// 
/// Использовать Telegram API для автоматического получения информации о боте:
/// 
/// Future<String> _getBotName(String token) async {
///   try {
///     final response = await http.get(
///       Uri.parse('https://api.telegram.org/bot$token/getMe'),
///     );
///     
///     if (response.statusCode == 200) {
///       final data = json.decode(response.body);
///       return data['result']['first_name'] ?? 'Бот';
///     }
///     return 'Бот';
///   } catch (e) {
///     return 'Бот';
///   }
/// }
/// 
/// // Автозаполнение имени при изменении токена
/// void _onTokenChanged(String value) async {
///   if (value.length > 30) { // Проверяем что токен достаточно длинный
///     final botName = await _getBotName(value);
///     if (botName.isNotEmpty && _nameController.text.isEmpty) {
///       setState(() {
///         _nameController.text = botName;
///       });
///     }
///   }
/// }
/// 

/// 3. БЕЗОПАСНОЕ ХРАНЕНИЕ ТОКЕНОВ
/// ----------------------------------------------------------------------------
/// 
/// Использовать безопасное хранилище для токенов:
/// 
/// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
/// 
/// final storage = FlutterSecureStorage();
/// 
/// // Сохранение токена
/// await storage.write(key: 'bot_token_${account.id}', value: account.token);
/// 
/// // Получение токена
/// final token = await storage.read(key: 'bot_token_${account.id}');
/// 

/// 4. ПОДДЕРЖКА MULTI-SESSION
/// ----------------------------------------------------------------------------
/// 
/// Реализовать работу с несколькими аккаунтами одновременно:
/// 
/// class AccountManager {
///   final Map<String, TelegramService> _activeSessions = {};
///   
///   Future<void> addAccount(Account account) async {
///     final service = TelegramService(account.token);
///     await service.initialize();
///     _activeSessions[account.id] = service;
///   }
///   
///   Future<void> removeAccount(String accountId) async {
///     await _activeSessions[accountId]?.dispose();
///     _activeSessions.remove(accountId);
///   }
/// }
/// 

/// 5. ОБРАБОТКА ОШИБОК АВТОРИЗАЦИИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить обработку различных ошибок API:
/// 
/// void _handleSubmit() async {
///   try {
///     // ... существующий код
///   } on http.ClientException catch (e) {
///     // Ошибка сети
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text('Ошибка сети: ${e.message}')),
///     );
///   } on FormatException catch (e) {
///     // Ошибка формата ответа
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text('Неверный формат ответа')),
///     );
///   } catch (e) {
///     // Общая ошибка
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text('Ошибка подключения: $e')),
///     );
///   } finally {
///     setState(() => _isLoading = false);
///   }
/// }
/// 

/// 6. ИНДИКАТОР ПРОЦЕССА ПОДКЛЮЧЕНИЯ
/// ----------------------------------------------------------------------------
/// 
/// Добавить подробную информацию о процессе подключения:
/// 
/// enum ConnectionState {
///   connecting,
///   validating,
///   fetchingInfo,
///   ready,
///   error
/// }
/// 
/// ConnectionState _connectionState = ConnectionState.connecting;
/// 
/// // Обновлять состояние и отображать прогресс
/// 

/// 7. QR-CODE СКАНИРОВАНИЕ ДЛЯ БЫСТРОГО ДОБАВЛЕНИЯ
/// ----------------------------------------------------------------------------
/// 
/// Добавить альтернативный способ добавления аккаунта:
/// 
/// import 'package:mobile_scanner/mobile_scanner.dart';
/// 
/// void _scanQrCode() async {
///   final result = await Navigator.push(context, 
///     MaterialPageRoute(builder: (context) => QrScannerScreen()));
///   
///   if (result != null) {
///     _tokenController.text = result;
///   }
/// }
/// 

/// 8. ИМПОРТ/ЭКСПОРТ КОНФИГУРАЦИИ АККАУНТОВ
/// ----------------------------------------------------------------------------
/// 
/// Добавить возможность сохранения и восстановления конфигурации:
/// 
/// void _exportAccounts() async {
///   final accounts = await _accountManager.getAccounts();
///   final config = json.encode(accounts);
///   // Сохранить в файл или поделиться
/// }
/// 
/// void _importAccounts(String config) async {
///   final accounts = json.decode(config) as List;
///   for (final accountData in accounts) {
///     final account = Account.fromJson(accountData);
///     await _accountManager.addAccount(account);
///   }
/// }
/// 

/// 9. ПРОВЕРКА ПРАВ ДОСТУПА БОТА
/// ----------------------------------------------------------------------------
/// 
/// Проверять какие возможности есть у бота:
/// 
/// Future<Map<String, bool>> _getBotCapabilities(String token) async {
///   final response = await http.get(
///     Uri.parse('https://api.telegram.org/bot$token/getMe'),
///   );
///   
///   // Анализировать доступные функции бота
///   return {
///     'canReadMessages': true,
///     'canSendMessages': true,
///     'canJoinGroups': data['can_join_groups'] ?? false,
///     // ... другие возможности
///   };
/// }
/// 

/// 10. АВТОМАТИЧЕСКОЕ ОБНОВЛЕНИЕ ИНФОРМАЦИИ О БОТЕ
/// ----------------------------------------------------------------------------
/// 
/// Периодически обновлять информацию о подключенных ботах:
/// 
/// void _startBotInfoUpdater() {
///   Timer.periodic(Duration(hours: 1), (timer) async {
///     for (final account in accounts) {
///       final newInfo = await _getBotInfo(account.token);
///       // Обновить информацию в базе данных
///     }
///   });
/// }
/// 

/// 11. ПОДДЕРЖКА ПРОКСИ И НАСТРОЕК СЕТИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить настройки подключения для обхода блокировок:
/// 
/// class NetworkSettings {
///   final String proxyUrl;
///   final int proxyPort;
///   final String proxyUsername;
///   final String proxyPassword;
///   final bool useSystemProxy;
/// }
/// 

/// 12. ЛОГИРОВАНИЕ ПРОЦЕССА ПОДКЛЮЧЕНИЯ
/// ----------------------------------------------------------------------------
/// 
/// Добавить детальное логирование для отладки:
/// 
/// void _logConnectionProcess(String message) {
///   if (kDebugMode) {
///     print('[$_connectionState] $message');
///   }
///   // Также можно сохранять в файл для последующего анализа
/// }
/// 

/// 13. ПОДДЕРЖКА РАЗЛИЧНЫХ ТИПОВ АККАУНТОВ
/// ----------------------------------------------------------------------------
/// 
/// Расширить систему для поддержки разных типов аккаунтов:
/// 
/// enum AccountType {
///   bot,
///   user, // Для будущей поддержки user accounts
///   test,
///   commercial
/// }
/// 

/// 14. ВАЛИДАЦИЯ ФОРМАТА ТОКЕНА
/// ----------------------------------------------------------------------------
/// 
/// Добавить проверку формата токена на стороне клиента:
/// 
/// bool _isValidTokenFormat(String token) {
///   final regex = RegExp(r'^\d+:[A-Za-z0-9_-]+$');
///   return regex.hasMatch(token);
/// }
/// 
/// // В валидаторе:
/// if (!_isValidTokenFormat(value)) {
///   return 'Неверный формат токена';
/// }
/// 

/// 15. ИНТЕГРАЦИЯ С СИСТЕМОЙ НАСТРОЕК БОТА
/// ----------------------------------------------------------------------------
/// 
/// Предоставить быстрый доступ к настройкам бота:
/// 
/// void _openBotSettings(String token) {
///   final url = 'https://t.me/BotFather?start=$token';
///   // Открыть в браузере или WebView
/// }
/// 

/// 16. ПОДДЕРЖКА ТЕСТОВЫХ СРЕД
/// ----------------------------------------------------------------------------
/// 
/// Добавить возможность работы с test environment:
/// 
/// bool _isTestEnvironment = false;
/// 
/// String get _apiBaseUrl => _isTestEnvironment 
///     ? 'https://api.telegram.org/bot/test/'
///     : 'https://api.telegram.org/bot/';
/// 

/// 17. АВТОМАТИЧЕСКОЕ ВОССТАНОВЛЕНИЕ СОЕДИНЕНИЯ
/// ----------------------------------------------------------------------------
/// 
/// Реализовать механизм переподключения при обрыве:
/// 
/// class ReconnectableTelegramService {
///   Future<void> connectWithRetry({
///     int maxRetries = 3,
///     Duration delay = const Duration(seconds: 2),
///   }) async {
///     for (int attempt = 1; attempt <= maxRetries; attempt++) {
///       try {
///         await connect();
///         return;
///       } catch (e) {
///         if (attempt == maxRetries) rethrow;
///         await Future.delayed(delay * attempt);
///       }
///     }
///   }
/// }
/// 

/// 18. СИСТЕМА УВЕДОМЛЕНИЙ О СТАТУСЕ АККАУНТА
/// ----------------------------------------------------------------------------
/// 
/// Уведомлять пользователя о статусе подключения:
/// 
/// void _showConnectionStatus(ConnectionStatus status) {
///   final message = switch (status) {
///     ConnectionStatus.connected => 'Аккаунт успешно подключен',
///     ConnectionStatus.disconnected => 'Соединение разорвано',
///     ConnectionStatus.error => 'Ошибка подключения',
///   };
///   
///   ScaffoldMessenger.of(context).showSnackBar(
///     SnackBar(content: Text(message)),
///   );
/// }
/// 

/// 19. ПОДДЕРЖКА МИГРАЦИИ АККАУНТОВ
/// ----------------------------------------------------------------------------
/// 
/// Обеспечить совместимость при обновлениях приложения:
/// 
/// void _migrateAccountData(Account account, int fromVersion) {
///   switch (fromVersion) {
///     case 1:
///       // Миграция с версии 1 на 2
///       break;
///     case 2:
///       // Миграция с версии 2 на 3
///       break;
///   }
/// }
/// 

/// 20. ИНТЕГРАЦИЯ С СИСТЕМОЙ АНАЛИТИКИ
/// ----------------------------------------------------------------------------
/// 
/// Отслеживание событий добавления аккаунтов:
/// 
/// void _trackAddAccountEvent(bool success) {
///   analytics.logEvent(
///     name: 'account_added',
///     parameters: {
///       'success': success,
///       'timestamp': DateTime.now().toString(),
///     },
///   );
/// }
/// 