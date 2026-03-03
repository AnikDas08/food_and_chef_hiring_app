class NotificationModel {
  String? id;
  String? title;
  List<String>? receiver;
  String? message;
  String? filePath;
  bool? isRead;
  String? referenceId;
  List<String>? readers;
  String? createdAt;
  String? updatedAt;

  NotificationModel({
    this.id,
    this.title,
    this.receiver,
    this.message,
    this.filePath,
    this.isRead,
    this.referenceId,
    this.readers,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      title: json['title'],
      // Mapping the lists safely
      receiver: json['receiver'] != null
          ? List<String>.from(json['receiver'])
          : [],
      message: json['message'],
      filePath: json['filePath'],
      isRead: json['isRead'],
      referenceId: json['referenceId'],
      readers: json['readers'] != null
          ? List<String>.from(json['readers'])
          : [],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // Optional: Add a method to convert model back to JSON if needed for POST/PATCH
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'receiver': receiver,
      'message': message,
      'filePath': filePath,
      'isRead': isRead,
      'referenceId': referenceId,
      'readers': readers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}