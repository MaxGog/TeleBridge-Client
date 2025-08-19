import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tdlib/td_client.dart';
import 'package:tdlib/td_api.dart' as td;

class TdLibService {
  static final TdLibService _instance = TdLibService._internal();
  factory TdLibService() => _instance;
  TdLibService._internal();

  late TdClient _client;
  final StreamController<td.TdObject> _updateController = 
      StreamController<td.TdObject>.broadcast();
  
  final Map<int, Completer<td.TdObject>> _pendingRequests = {};
  int _currentRequestId = 0;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final appSupportDir = await getApplicationSupportDirectory();

      print('Initializing TDLib in: ${documentsDir.path}');
      
      _client = TdClient.create();
      
      // Настройка параметров TDLib
      final parametersResult = await _sendCommand(td.SetTdlibParameters(
        parameters: td.TdlibParameters(
          useTestDc: false,
          databaseDirectory: documentsDir.path,
          filesDirectory: appSupportDir.path,
          useFileDatabase: true,
          useChatInfoDatabase: true,
          useMessageDatabase: true,
          useSecretChats: false,
          apiId:  YOUR_API_ID, // ЗАМЕНИТЕ на свой
          apiHash: 'YOUR_API_HASH', // ЗАМЕНИТЕ на свой
          systemLanguageCode: Platform.localeName.split('_')[0],
          deviceModel: Platform.isAndroid ? 'Android' : 'iOS',
          systemVersion: Platform.version,
          applicationVersion: '1.0',
          enableStorageOptimizer: true,
        ),
      ));

      if (parametersResult is td.Error) {
        throw Exception('TDLib parameters error: ${parametersResult.message}');
      }

      // Обработка обновлений
      _client.updates.listen((update) {
        _updateController.add(update);
        _handleUpdate(update);
      }, onError: (error) {
        print('TDLib update error: $error');
      });

      // Проверяем состояние базы данных
      final checkResult = await _sendCommand(td.CheckDatabaseEncryptionKey());
      if (checkResult is td.Error) {
        throw Exception('Database error: ${checkResult.message}');
      }

      _isInitialized = true;
      print('TDLib initialized successfully');

    } catch (e) {
      print('TDLib initialization failed: $e');
      rethrow;
    }
  }

  Future<td.TdObject> _sendCommand(td.TdFunction function) async {
    final requestId = _currentRequestId++;
    final completer = Completer<td.TdObject>();
    _pendingRequests[requestId] = completer;

    try {
      final jsonString = function.toJson();
      final jsonPointer = jsonString.toNativeUtf8();
      
      _client.send(requestId, jsonPointer.cast());
      malloc.free(jsonPointer);

      // Таймаут для запроса
      return await completer.future.timeout(const Duration(seconds: 30));
    } catch (e) {
      _pendingRequests.remove(requestId);
      completer.completeError(e);
      rethrow;
    }
  }

  void _handleResponse(int requestId, td.TdObject response) {
    final completer = _pendingRequests.remove(requestId);
    if (completer != null) {
      if (response is td.Error) {
        completer.completeError(Exception(response.message));
      } else {
        completer.complete(response);
      }
    }
  }

  void _handleUpdate(td.TdObject update) {
    print('TDLib update: ${update.runtimeType}');
    
    if (update is td.UpdateAuthorizationState) {
      _handleAuthorizationState(update.authorizationState);
    } else if (update is td.UpdateConnectionState) {
      print('Connection state: ${update.state}');
    }
    
    // Пересылаем обновления в контроллер
    _updateController.add(update);
  }

  void _handleAuthorizationState(td.AuthorizationState state) {
    print('Authorization state: ${state.runtimeType}');
    
    if (state is td.AuthorizationStateWaitTdlibParameters) {
      print('TDLib parameters needed');
    } else if (state is td.AuthorizationStateWaitEncryptionKey) {
      // Отправляем пустой encryption key
      _sendCommand(td.CheckDatabaseEncryptionKey());
    } else if (state is td.AuthorizationStateWaitPhoneNumber) {
      print('Need phone number');
    } else if (state is td.AuthorizationStateWaitCode) {
      print('Need authentication code');
    } else if (state is td.AuthorizationStateWaitPassword) {
      print('Need password');
    } else if (state is td.AuthorizationStateReady) {
      print('Authorization ready!');
    } else if (state is td.AuthorizationStateLoggingOut) {
      print('Logging out...');
    } else if (state is td.AuthorizationStateClosed) {
      print('Authorization closed');
    }
  }

  // Получение информации о файле
  Future<String?> getFileUrl(int fileId) async {
    final result = await _sendCommand(td.GetFile(fileId: fileId));
    if (result is td.File) {
      return result.local?.path;
    }
    return null;
  }

  // Получение информации о пользователе
  Future<td.User> getUser(int userId) async {
    final result = await _sendCommand(td.GetUser(userId: userId));
    if (result is td.User) {
      return result;
    }
    throw Exception('Failed to get user: $result');
  }

  // Получение аватара чата
  Future<String?> getChatAvatar(int chatId) async {
    final result = await _sendCommand(td.GetChat(chatId: chatId));
    if (result is td.Chat) {
      if (result.photo != null) {
        final fileResult = await getFileUrl(result.photo!.small.id);
        return fileResult;
      }
    }
    return null;
  }

  Stream<td.TdObject> get updates => _updateController.stream;

  Future<td.AuthorizationState> getAuthorizationState() async {
    final result = await _sendCommand(td.GetAuthorizationState());
    if (result is td.AuthorizationState) {
      return result;
    }
    throw Exception('Failed to get authorization state');
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    final result = await _sendCommand(td.SetAuthenticationPhoneNumber(
      phoneNumber: phoneNumber,
      settings: td.PhoneNumberAuthenticationSettings(),
    ));
    
    if (result is td.Error) {
      throw Exception(result.message);
    }
  }

  Future<void> checkAuthenticationCode(String code) async {
    final result = await _sendCommand(td.CheckAuthenticationCode(code: code));
    if (result is td.Error) {
      throw Exception(result.message);
    }
  }

  Future<void> checkAuthenticationPassword(String password) async {
    final result = await _sendCommand(td.CheckAuthenticationPassword(
      password: password,
    ));
    if (result is td.Error) {
      throw Exception(result.message);
    }
  }

  Future<List<td.Chat>> getChats() async {
    final result = await _sendCommand(td.GetChats(
      offsetOrder: 9223372036854775807, // Большое число для получения последних чатов
      limit: 20,
    ));
    
    if (result is td.Chats) {
      final chats = <td.Chat>[];
      for (var chatId in result.chatIds) {
        try {
          final chatResult = await _sendCommand(td.GetChat(chatId: chatId));
          if (chatResult is td.Chat) {
            chats.add(chatResult);
          }
        } catch (e) {
          print('Error getting chat $chatId: $e');
        }
      }
      return chats;
    }
    
    if (result is td.Error) {
      throw Exception(result.message);
    }
    
    return [];
  }

  Future<List<td.Message>> getMessages(int chatId, [int fromMessageId = 0]) async {
    final result = await _sendCommand(td.GetChatHistory(
      chatId: chatId,
      fromMessageId: fromMessageId,
      offset: 0,
      limit: 50,
      onlyLocal: false,
    ));
    
    if (result is td.Messages) {
      return result.messages ?? [];
    }
    
    if (result is td.Error) {
      throw Exception(result.message);
    }
    
    return [];
  }

  Future<void> sendMessage(int chatId, String text) async {
    final result = await _sendCommand(td.SendMessage(
      chatId: chatId,
      inputMessageContent: td.InputMessageText(
        text: td.FormattedText(text: text, entities: []),
        clearDraft: true,
      ),
    ));
    
    if (result is td.Error) {
      throw Exception(result.message);
    }
  }

  Future<void> sendPhoto(int chatId, String filePath) async {
    final result = await _sendCommand(td.SendMessage(
      chatId: chatId,
      inputMessageContent: td.InputMessagePhoto(
        photo: td.InputFileLocal(path: filePath),
        caption: td.FormattedText(text: '', entities: []),
      ),
    ));
    
    if (result is td.Error) {
      throw Exception(result.message);
    }
  }

  Future<void> logout() async {
    final result = await _sendCommand(td.LogOut());
    if (result is td.Error) {
      throw Exception(result.message);
    }
  }

  Future<void> close() async {
    final result = await _sendCommand(td.Close());
    if (result is td.Error) {
      print('Error closing TDLib: ${result.message}');
    }
    _updateController.close();
  }

  void dispose() {
    close();
    _client.destroy();
    _isInitialized = false;
  }
}