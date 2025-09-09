class TelegramUser {
  final int id;
  final bool isBot;
  final String firstName;
  final String? lastName;
  final String? username;

  TelegramUser({
    required this.id,
    required this.isBot,
    required this.firstName,
    this.lastName,
    this.username,
  });

  factory TelegramUser.fromJson(Map<String, dynamic> json) {
    return TelegramUser(
      id: json['id'],
      isBot: json['is_bot'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
    );
  }
}