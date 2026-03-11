import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../../utils/extensions/extension.dart';

class ChatBubbleMessage extends StatelessWidget {
  final DateTime time;
  final String text;
  final String avatarImage;
  final String localImagePath;
  final bool isMe;
  final bool isNotice;
  final String type;
  final List<String> docs;
  final List<String> images;
  final VoidCallback onTap;

  const ChatBubbleMessage({
    super.key,
    required this.time,
    required this.text,
    required this.avatarImage,
    required this.isMe,
    required this.onTap,
    this.localImagePath = '',
    this.isNotice = false,
    this.type = 'text',
    this.docs = const [],
    this.images = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (isNotice) return _buildNoticeMessage();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16.sp,
              backgroundColor: Colors.grey[200],
              child: ClipOval(child: _buildAvatarImage()),
            ),
            8.width,
          ],

          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Get.width * 0.72),
              child: Column(
                crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  _buildBubble(),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 4.h, left: 4.w, right: 4.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isMe) ...[
                          CommonImage(imageSrc: AppIcons.sended),
                          4.width,
                        ],
                        CommonText(
                          text: time.time.toString(),
                          fontSize: 10,
                          color: const Color(0xff999999),
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isMe) ...[
            8.width,
            CircleAvatar(
              radius: 16.sp,
              backgroundColor: Colors.grey[200],
              child: ClipOval(child: _buildAvatarImage()),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Bubble Router ─────────────────────────────────────────────────────────

  Widget _buildBubble() {
    switch (type) {
      case 'image':
        return _buildImageBubble();
      case 'document':
        return _buildDocumentBubble();
      default:
        return _buildTextBubble();
    }
  }

  // ─── Text Bubble ───────────────────────────────────────────────────────────

  Widget _buildTextBubble() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xffFD713F) : const Color(0xffF0F0F0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
          bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
          bottomRight: Radius.circular(isMe ? 4.r : 18.r),
        ),
      ),
      child: CommonText(
        maxLines: 100,
        text: text.isEmpty ? '...' : text,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: isMe ? Colors.white : const Color(0xff222222),
        textAlign: isMe ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  // ─── Image Bubble ──────────────────────────────────────────────────────────

  Widget _buildImageBubble() {
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        /// ✅ Local file — just sent optimistically
        if (localImagePath.isNotEmpty)
          _buildImageContainer(child: _localImage(localImagePath))

        /// ✅ Network images from API
        else if (images.isNotEmpty)
          ...images.map((img) =>
              _buildImageContainer(child: _networkImage(img)))

        /// Fallback
        else
          _buildImageContainer(
            child: Container(
              color: const Color(0xffF0F0F0),
              child: const Center(
                child: Icon(Icons.broken_image_outlined,
                    color: Colors.grey, size: 32),
              ),
            ),
          ),

        /// Caption
        if (text.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            padding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color:
              isMe ? const Color(0xffFD713F) : const Color(0xffF0F0F0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
                bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
                bottomRight: Radius.circular(isMe ? 4.r : 18.r),
              ),
            ),
            child: CommonText(
              text: text,
              fontSize: 13,
              color: isMe ? Colors.white : const Color(0xff222222),
            ),
          ),
      ],
    );
  }

  /// Clips and rounds the image into a bubble shape
  Widget _buildImageContainer({required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
          bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
          bottomRight: Radius.circular(isMe ? 4.r : 18.r),
        ),
        child: SizedBox(
          width: Get.width * 0.62,
          height: 220.h,
          child: child,
        ),
      ),
    );
  }

  /// ✅ Local image from file system
  Widget _localImage(String path) {
    return Image.file(
      File(path),
      width: Get.width * 0.62,
      height: 220.h,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xffF0F0F0),
        child: const Center(
          child: Icon(Icons.broken_image_outlined,
              color: Colors.grey, size: 32),
        ),
      ),
    );
  }

  /// ✅ Network image from API
  Widget _networkImage(String imgPath) {
    final url =
    imgPath.startsWith('http') ? imgPath : '${ApiEndPoint.imageUrl}$imgPath';
    return Image.network(
      url,
      width: Get.width * 0.62,
      height: 220.h,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: const Color(0xffF0F0F0),
          child: Center(
            child: CircularProgressIndicator(
              color: const Color(0xffFD713F),
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xffF0F0F0),
        child: const Center(
          child: Icon(Icons.broken_image_outlined,
              color: Colors.grey, size: 32),
        ),
      ),
    );
  }

  // ─── Document Bubble ───────────────────────────────────────────────────────

  Widget _buildDocumentBubble() {
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (docs.isNotEmpty)
          ...docs.map((doc) => _buildDocItem(doc))
        else
          _buildDocItem(''),

        if (text.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            padding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color:
              isMe ? const Color(0xffFD713F) : const Color(0xffF0F0F0),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: CommonText(
              text: text,
              fontSize: 13,
              color: isMe ? Colors.white : const Color(0xff222222),
            ),
          ),
      ],
    );
  }

  Widget _buildDocItem(String docPath) {
    final fileName =
    docPath.isNotEmpty ? docPath.split('/').last : 'Document';
    final ext = fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : 'FILE';
    final Color docColor = _docColor(ext);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xffFD713F) : const Color(0xffF0F0F0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
            bottomRight: Radius.circular(isMe ? 4.r : 18.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 40.sp,
                  height: 44.sp,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.insert_drive_file_rounded,
                    color:
                    isMe ? Colors.white : const Color(0xff555555),
                    size: 26.sp,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: docColor,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Text(
                    ext.length > 4 ? ext.substring(0, 4) : ext,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            10.width,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    maxLines: 2,
                    text: fileName,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                    isMe ? Colors.white : const Color(0xff222222),
                  ),
                  4.height,
                  CommonText(
                    text: "Tap to open",
                    fontSize: 10,
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.7)
                        : const Color(0xff999999),
                  ),
                ],
              ),
            ),
            10.width,
            Icon(
              Icons.download_rounded,
              size: 18.sp,
              color: isMe
                  ? Colors.white.withValues(alpha: 0.8)
                  : const Color(0xff777777),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Notice ────────────────────────────────────────────────────────────────

  Widget _buildNoticeMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.w),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xffDDDDDD))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CommonText(
              text: text,
              fontSize: 11,
              color: const Color(0xff999999),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xffDDDDDD))),
        ],
      ),
    );
  }

  // ─── Avatar ────────────────────────────────────────────────────────────────

  Widget _buildAvatarImage() {
    if (avatarImage.isEmpty) {
      return Container(
        color: const Color(0xffEEEEEE),
        child: Icon(Icons.person, size: 18.sp, color: Colors.grey),
      );
    }
    final url = avatarImage.startsWith('http')
        ? avatarImage
        : '${ApiEndPoint.imageUrl}$avatarImage';
    return Image.network(
      url,
      width: 32.sp,
      height: 32.sp,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xffEEEEEE),
        child: Icon(Icons.person, size: 18.sp, color: Colors.grey),
      ),
    );
  }

  // ─── Doc color ─────────────────────────────────────────────────────────────

  Color _docColor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':  return Colors.red;
      case 'doc':
      case 'docx': return Colors.blue;
      case 'xls':
      case 'xlsx': return Colors.green;
      case 'txt':  return Colors.grey;
      default:     return const Color(0xffFD713F);
    }
  }
}