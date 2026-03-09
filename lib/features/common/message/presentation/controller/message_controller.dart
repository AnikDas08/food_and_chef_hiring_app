import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../services/socket/socket_service.dart';
import '../../../../../services/storage/storage_services.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../utils/enum/enum.dart';
import '../../data/model/chat_message_model.dart';

class MessageController extends GetxController {
  bool isLoading = false;
  bool isMoreLoading = false;
  bool isSendingImage = false;
  bool isSending = false;

  List<ChatMessageModel> messages = [];

  String chatId = "";
  String name = "";
  String image = "";

  int page = 1;
  int totalPage = 1;
  Status status = Status.completed;

  File? selectedImage;
  File? selectedDoc;
  String? selectedDocName;

  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  static MessageController get instance => Get.put(MessageController());

  // ─── Fetch Messages ────────────────────────────────────────────────────────

  Future<void> getMessageRepo() async {
    if (page == 1) {
      messages.clear();
      isLoading = true;
      update();
    }

    var response = await ApiService.get(
      "${ApiEndPoint.messages}/$chatId?page=$page&limit=20",
    );

    if (response.statusCode == 200) {
      var pagination = response.data['data']['pagination'];
      totalPage = pagination['totalPage'] ?? 1;

      var data = response.data['data']['messages'] as List? ?? [];

      if (page == 1) messages.clear();

      for (var item in data) {
        final senderId = item['sender'] ?? '';
        final bool isMe = LocalStorage.userId == senderId;

        if (kDebugMode) {
          print("MyId: ${LocalStorage.userId} | SenderId: $senderId | isMe: $isMe");
        }

        messages.add(
          ChatMessageModel(
            id: item['_id'] ?? '',
            time: DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now(),
            text: item['text'] ?? '',
            avatarImage: isMe ? (LocalStorage.myImage ?? '') : '',
            localImagePath: '',
            isMe: isMe,
            isNotice: item['type'] == 'notice',
            docs: List<String>.from(item['docs'] ?? []),
            images: List<String>.from(item['image'] ?? []),
            type: item['type'] ?? 'text',
            seen: item['seen'] ?? false,
          ),
        );
      }

      page++;
      isLoading = false;
      status = Status.completed;
      update();
    } else {
      Utils.errorSnackBar(response.statusCode.toString(), response.message);
      isLoading = false;
      status = Status.error;
      update();
    }
  }

  // ─── Image Picker ──────────────────────────────────────────────────────────

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        update();
        Get.back(); // close bottom sheet
        await sendImageMessage();
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to pick image from camera");
      if (kDebugMode) print("Camera error: $e");
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        update();
        Get.back(); // close bottom sheet
        await sendImageMessage();
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to pick image from gallery");
      if (kDebugMode) print("Gallery error: $e");
    }
  }

  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Camera'),
              onTap: pickImageFromCamera,
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Gallery'),
              onTap: pickImageFromGallery,
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Cancel'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Send Image ────────────────────────────────────────────────────────────

  Future<void> sendImageMessage() async {
    if (selectedImage == null) return;

    try {
      isSendingImage = true;
      update();

      Map<String, String> body = {
        'chatId': chatId,
        'type': 'image',
      };

      if (messageController.text.trim().isNotEmpty) {
        body['text'] = messageController.text.trim();
        messageController.clear();
      }

      List<Map<String, String>> files = [
        {
          'name': 'image',
          'image': selectedImage!.path,
        }
      ];

      var response = await ApiService.multipartImage(
        ApiEndPoint.messages,
        body: body,
        files: files,
        method: "POST",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        /// ✅ No optimistic insert — socket will push the message back
        selectedImage = null;
      } else {
        Utils.errorSnackBar("Error", response.message ?? "Failed to send image");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to send image: ${e.toString()}");
      if (kDebugMode) print("Send image error: $e");
    } finally {
      isSendingImage = false;
      update();
    }
  }

  // ─── Document Picker ───────────────────────────────────────────────────────

  Future<void> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        selectedDoc = File(result.files.single.path!);
        selectedDocName = result.files.single.name;
        selectedImage = null;
        update();
        await sendDocMessage();
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to pick document");
      if (kDebugMode) print("Doc picker error: $e");
    }
  }

  // ─── Send Document ─────────────────────────────────────────────────────────

  Future<void> sendDocMessage() async {
    if (selectedDoc == null) return;

    try {
      isSendingImage = true;
      update();

      Map<String, String> body = {
        'chatId': chatId,
        'type': 'document',
      };

      if (messageController.text.trim().isNotEmpty) {
        body['text'] = messageController.text.trim();
        messageController.clear();
      }

      List<Map<String, String>> files = [
        {
          'name': 'doc',
          'image': selectedDoc!.path,
        }
      ];

      var response = await ApiService.multipartImage(
        ApiEndPoint.messages,
        body: body,
        files: files,
        method: "POST",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        /// ✅ No optimistic insert — socket will push the message back
        selectedDoc = null;
        selectedDocName = null;
      } else {
        Utils.errorSnackBar("Error", response.message ?? "Failed to send document");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to send document: ${e.toString()}");
      if (kDebugMode) print("Send doc error: $e");
    } finally {
      isSendingImage = false;
      update();
    }
  }

  // ─── Send Text ─────────────────────────────────────────────────────────────

  Future<void> addNewMessage() async {
    if (messageController.text.trim().isEmpty) return;

    var body = {
      "chatId": chatId,
      "text": messageController.text.trim(),
      "type": "text",
    };

    String messageText = messageController.text.trim();
    messageController.clear();

    try {
      isSending = true;
      update();

      var response = await ApiService.post(
        ApiEndPoint.messages,
        body: body,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        /// restore text on failure
        messageController.text = messageText;
        Utils.errorSnackBar("Error", "Failed to send message");
      }

      /// ✅ No optimistic insert — socket will push the message back
    } catch (e) {
      messageController.text = messageText;
      Utils.errorSnackBar("Error", "Failed to send message");
      if (kDebugMode) print("Send message error: $e");
    } finally {
      isSending = false;
      update();
    }
  }

  // ─── Socket Listener ───────────────────────────────────────────────────────

  void listenMessage(String chatId) {
    SocketServices.on('getMessage::$chatId', (data) {
      if (kDebugMode) print("Socket data: $data");

      /// Duplicate check by _id
      String messageId = data['_id'] ?? '';
      bool messageExists = messages.any((msg) => msg.id == messageId);
      if (messageExists) return;

      final String senderId = data['sender'] ?? '';
      final bool isMe = LocalStorage.userId == senderId;

      if (kDebugMode) {
        print("Socket => MyId: ${LocalStorage.userId} | SenderId: $senderId | isMe: $isMe");
      }

      messages.insert(
        0,
        ChatMessageModel(
          id: messageId,
          isNotice: data['type'] == "notice",
          time: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
          text: data['text'] ?? '',
          avatarImage: isMe ? (LocalStorage.myImage ?? '') : '',
          localImagePath: '',
          isMe: isMe,
          type: data['type'] ?? 'text',
          docs: List<String>.from(data['docs'] ?? []),
          images: List<String>.from(data['image'] ?? []),
          seen: false,
        ),
      );
      update();
    });
  }

  // ─── Init ──────────────────────────────────────────────────────────────────

  void init(String id) {
    if (kDebugMode) print("Chat ID: $id");
    chatId = id;
    page = 1;
    messages.clear();
    getMessageRepo();
    listenMessage(chatId);
  }

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent &&
          !isMoreLoading &&
          !isLoading &&
          page <= totalPage) {
        isMoreLoading = true;
        update();
        getMessageRepo().then((_) {
          isMoreLoading = false;
          update();
        });
      }
    });

    if (Get.arguments != null) {
      name = Get.arguments['name'] ?? '';
      image = Get.arguments['image'] ?? '';
      final String id = Get.arguments['chatId'] ?? '';

      if (id.isNotEmpty) {
        init(id);
      }
    }
  }

  @override
  void onClose() {
    //SocketServices.off('getMessage::$chatId');
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}