class ChatListResponse {
  final bool success;
  final String message;
  final List<ChatModel> data;

  ChatListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ChatModel.fromJson(e))
          .toList(),
    );
  }
}

class ChatModel {
  final String id;
  final Participant participant;
  final LatestMessage latestMessage;

  ChatModel({
    required this.id,
    required this.participant,
    required this.latestMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      participant: Participant.fromJson(json['participants'] ?? {}),
      latestMessage: LatestMessage.fromJson(json['lastMessage'] ?? {}),
    );
  }
}

class Participant {
  final String id;
  final String fullName;
  final String image;
  final String contact;

  Participant({
    required this.id,
    required this.fullName,
    required this.image,
    this.contact = '',
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] ?? '',
      fullName: json['name'] ?? '',
      image: json['image'] ?? '',
      contact: json['contact'] ?? '',
    );
  }
}

class LatestMessage {
  final String id;
  final String message;
  final String sender;
  final DateTime createdAt;
  final String type;        // ← add this

  LatestMessage({
    required this.id,
    this.message = '',
    this.sender = '',
    required this.createdAt,
    this.type = 'text',     // ← add this
  });

  // ✅ Smart display text
  String get displayMessage {
    if (message.isNotEmpty) return message;
    switch (type) {
      case 'image': return '📷 Photo';
      case 'document': return '📎 File';
      default: return '';
    }
  }

  factory LatestMessage.fromJson(Map<String, dynamic> json) {
    return LatestMessage(
      id: json['_id'] ?? '',
      message: json['text']?.toString() ?? 'Send a file',
      sender: json['sender']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',   // ← add this
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}