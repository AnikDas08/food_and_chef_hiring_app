class ChatMessageModel {
  final String id;
  final DateTime time;
  final String text;
  final String avatarImage;  // sender avatar
  final String localImagePath; // local file path for optimistic image
  final bool isMe;
  final bool isNotice;
  final bool seen;
  final String type;
  final List<String> docs;
  final List<String> images; // network image paths from API

  ChatMessageModel({
    this.id = '',
    required this.time,
    required this.text,
    required this.avatarImage,
    this.localImagePath = '',
    required this.isMe,
    this.isNotice = false,
    this.seen = false,
    this.type = 'text',
    this.docs = const [],
    this.images = const [],
  });
}