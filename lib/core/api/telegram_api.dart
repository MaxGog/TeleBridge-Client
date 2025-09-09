import 'package:dio/dio.dart';

class TelegramApiClient {
  static const String _baseUrl = 'https://api.telegram.org/bot';
  final String _token;
  final Dio _dio;

  TelegramApiClient(this._token) : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await _dio.get('${_baseUrl}$_token/getMe');
      return response.data;
    } on DioException catch (e) {
      throw e.error.toString();
    }
  }

  Future<Map<String, dynamic>> getUpdates({int? offset}) async {
    final data = offset != null ? {'offset': offset} : {};
    final response = await _dio.post('${_baseUrl}$_token/getUpdates', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> sendMessage({
    required int chatId,
    required String text,
    int? replyToMessageId,
  }) async {
    final data = {
      'chat_id': chatId,
      'text': text,
      'reply_to_message_id': replyToMessageId,
    };
    
    final response = await _dio.post(
      '${_baseUrl}$_token/sendMessage',
      data: data,
    );
    return response.data;
  }

  //Добавить другие методы API по надобности
}