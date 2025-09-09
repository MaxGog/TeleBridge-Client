import 'package:materialgramclient/core/models/attachment.dart';

class Message {
  final String text;
  final bool isMe;
  final String time;
  final List<Attachment> attachments;

  Message({
    required this.text,
    required this.isMe,
    required this.time,
    required this.attachments,
  });
}