import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/features/common/message/presentation/controller/chat_controller.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../data/model/chat_message_model.dart';
import '../../../../../../utils/extensions/extension.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../controller/message_controller.dart';
import '../widgets/chat_bubble_message.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String chatId = Get.parameters['chatId'] ?? '';
  String name = Get.parameters['name'] ?? '';
  String image = Get.parameters['image'] ?? '';

  @override
  void initState() {
    super.initState();
    MessageController.instance.name = name;
    MessageController.instance.image = image;
    MessageController.instance.init(chatId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,

          /// ── AppBar ──────────────────────────────────────────────────────
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              onPressed: () async{
                print('DEBUG: Back button pressed - resetting page and calling getChatRepo');
                final chatController = Get.find<ChatController>();
                chatController.page = 1; // Reset page to get fresh data
                await chatController.getChatRepo();
                print('DEBUG: getChatRepo completed, going back');
                Get.back();
              },
              icon: const Icon(
                CupertinoIcons.back,
                color: Color(0xff272727),
                size: 28,
              ),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                /// Participant image
                CircleAvatar(
                  radius: 20.sp,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CommonImage(
                      // Logic: If image starts with http, use it. Otherwise, add base URL.
                      imageSrc: image.startsWith('http')
                          ? image
                          : ApiEndPoint.imageUrl+image,
                      size: 40,
                      fill: BoxFit.fill,
                    ),
                  ),
                ),
                12.width,

                /// Participant name + status
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: name,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff272727),
                    ),
                    const CommonText(
                      text: 'Online',
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: Color(0xff4CAF50),
                    ),
                  ],
                ),
              ],
            ),
            /*actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined, color: Color(0xff272727)),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Color(0xff272727)),
              ),
            ],*/
          ),

          /// ── Body ────────────────────────────────────────────────────────
          body: Column(
            children: [
              /// Sending indicator
              if (controller.isSendingImage)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  color: const Color(0xffF2F2F2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 14.sp,
                        height: 14.sp,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xffFD713F),
                        ),
                      ),
                      8.width,
                      const CommonText(
                        text: 'Sending...',
                        fontSize: 12,
                        color: Color(0xff777777),
                      ),
                    ],
                  ),
                ),

              /// Messages list
              Expanded(
                child: controller.isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffFD713F),
                  ),
                )
                    : controller.messages.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.chat_bubble_2,
                        size: 48.sp,
                        color: const Color(0xff777777),
                      ),
                      8.height,
                      const CommonText(
                        text: 'No messages yet',
                        color: Color(0xff777777),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  reverse: true,
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 12.h,
                  ),
                  itemCount: controller.isMoreLoading
                      ? controller.messages.length + 1
                      : controller.messages.length,
                  itemBuilder: (context, index) {
                    /// Pagination loader
                    if (index == controller.messages.length) {
                      return Padding(
                        padding: EdgeInsets.all(16.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffFD713F),
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }

                    final ChatMessageModel message = controller.messages[index];

                    return ChatBubbleMessage(
                      localImagePath: message.localImagePath,
                      time: message.time,
                      text: message.text,
                      isMe: message.isMe,
                      isNotice: message.isNotice,
                      type: message.type,
                      docs: message.docs,
                      images: message.images,
                    );
                  },
                ),
              ),
            ],
          ),

          /// ── Bottom Input Bar ─────────────────────────────────────────────
          /// ── Bottom Input Bar ─────────────────────────────────────────────
          bottomNavigationBar: SafeArea(
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: Column(  // ← wrap with Column
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Top divider line
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: const Color(0xffEEEEEE),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 16.h,
                      top: 8.h,
                    ),
                    color: Colors.white,
                    child: Container(
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xffF6F6F6),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
                          /// Text input
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              onSubmitted: (_) => controller.addNewMessage(),
                              cursorColor: Color(0xff272727),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xff272727),
                              ),
                              decoration: InputDecoration(
                                hintText: "Type a message here...",
                                hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xff777777),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                              ),
                            ),
                          ),

                          /// Vertical divider
                          Container(
                            width: 1,
                            height: 24.h,
                            color: const Color(0xffDDDDDD),
                          ),

                          /// Send button
                          GestureDetector(
                            onTap: controller.isSending || controller.isSendingImage
                                ? null
                                : controller.addNewMessage,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: SvgPicture.asset(
                                'assets/icons/send_icons.svg',
                                width: 22.sp,
                                height: 22.sp,
                                colorFilter: ColorFilter.mode(
                                  controller.isSending || controller.isSendingImage
                                      ? const Color(0xffCCCCCC)
                                      : const Color(0xff272727),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          );
      },
    );
  }
}

/// ── Attachment Button Widget ───────────────────────────────────────────────
class _AttachmentButton extends StatelessWidget {
  final MessageController controller;

  const _AttachmentButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAttachmentSheet(context),
      child: Container(
        width: 46.sp,
        height: 46.sp,
        decoration: const BoxDecoration(
          color: Color(0xffF2F2F2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            CupertinoIcons.paperclip,
            size: 20.sp,
            color: const Color(0xff555555),
          ),
        ),
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.sp),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            20.height,

            /// Options row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _attachOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: const Color(0xff2196F3),
                  onTap: controller.pickImageFromCamera,
                ),
                _attachOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: const Color(0xff4CAF50),
                  onTap: controller.pickImageFromGallery,
                ),
                _attachOption(
                  icon: Icons.insert_drive_file_rounded,
                  label: 'Document',
                  color: const Color(0xffFD713F),
                  onTap: controller.pickDocument,
                ),
              ],
            ),
            20.height,
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _attachOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.sp,
            height: 56.sp,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: color, size: 26.sp),
            ),
          ),
          8.height,
          CommonText(
            text: label,
            fontSize: 12,
            color: const Color(0xff444444),
          ),
        ],
      ),
    );
  }
}