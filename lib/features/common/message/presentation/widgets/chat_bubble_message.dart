import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../../utils/extensions/extension.dart';
import 'package:new_untitled/config/api/api_end_point.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// CHAT BUBBLE MESSAGE
// ═══════════════════════════════════════════════════════════════════════════════

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

  const ChatBubbleMessage({
    super.key,
    required this.time,
    required this.text,
    required this.avatarImage,
    required this.isMe,
    this.localImagePath = '',
    this.isNotice = false,
    this.type = 'text',
    this.docs = const [],
    this.images = const [],
  });

  // ─── URL helper ────────────────────────────────────────────────────────────

  String _fullUrl(String path) =>
      path.startsWith('http') ? path : '${ApiEndPoint.imageUrl}$path';

  // ─── Actions ───────────────────────────────────────────────────────────────

  void _openImageViewer(BuildContext context, int index) {
    final validImages =
    images.where((e) => e.isNotEmpty).map(_fullUrl).toList();
    if (validImages.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _ImageViewerScreen(images: validImages, initialIndex: index),
      ),
    );
  }

  void _openDocument(String docPath) {
    if (docPath.isEmpty) return;
    final fileName = docPath.split('/').last;
    _FileDownloadHelper.downloadAndOpen(_fullUrl(docPath), fileName);
  }

  // ─── Root build ────────────────────────────────────────────────────────────

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
          // ── Other user avatar ──
          if (!isMe) ...[
            CircleAvatar(
              radius: 16.sp,
              backgroundColor: Colors.grey[200],
              child: ClipOval(child: _buildAvatarImage()),
            ),
            8.width,
          ],

          // ── Bubble + timestamp ──
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Get.width * 0.72),
              child: Column(
                crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  _buildBubble(context),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 4.h, left: 4.w, right: 4.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isMe) ...[
                          const CommonImage(imageSrc: AppIcons.sended),
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

          // ── My avatar ──
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

  // ─── Bubble router ─────────────────────────────────────────────────────────

  Widget _buildBubble(BuildContext context) {
    switch (type) {
      case 'image':
        return _buildImageBubble(context);
      case 'document':
        return _buildDocumentBubble();
      default:
        return _buildTextBubble();
    }
  }

  // ─── Text bubble ───────────────────────────────────────────────────────────

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

  // ─── Image bubble ──────────────────────────────────────────────────────────

  Widget _buildImageBubble(BuildContext context) {
    final validImages = images.where((e) => e.isNotEmpty).toList();

    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Local file — just picked, sending in progress
        if (localImagePath.isNotEmpty)
          _buildImageContainer(
            context: context,
            child: _localImage(localImagePath),
            index: 0,
            hasValidImages: false,
          )

        // Network images from API
        else if (validImages.isNotEmpty)
          ...validImages.asMap().entries.map(
                (e) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: _buildImageContainer(
                context: context,
                child: _networkImage(e.value),
                index: e.key,
                hasValidImages: true,
              ),
            ),
          )

        // Fallback — image was [null] or []
        else
          _buildImageContainer(
            context: context,
            index: 0,
            hasValidImages: false,
            child: Container(
              color: const Color(0xffEEEEEE),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image_outlined,
                      color: Colors.grey[400], size: 32.sp),
                  4.height,
                  Text(
                    'Image unavailable',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),

        // Optional caption below image
        if (text.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
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
              maxLines: 100,
              text: text,
              fontSize: 13,
              color: isMe ? Colors.white : const Color(0xff222222),
            ),
          ),
      ],
    );
  }

  Widget _buildImageContainer({
    required BuildContext context,
    required Widget child,
    required int index,
    required bool hasValidImages,
  }) {
    return GestureDetector(
      onTap: hasValidImages ? () => _openImageViewer(context, index) : null,
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

  Widget _localImage(String path) {
    return Image.file(
      File(path),
      width: Get.width * 0.62,
      height: 220.h,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _brokenImage(),
    );
  }

  Widget _networkImage(String imgPath) {
    return Image.network(
      _fullUrl(imgPath),
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
      errorBuilder: (_, __, ___) => _brokenImage(),
    );
  }

  Widget _brokenImage() {
    return Container(
      color: const Color(0xffEEEEEE),
      child: Center(
        child: Icon(Icons.broken_image_outlined,
            color: Colors.grey[400], size: 32.sp),
      ),
    );
  }

  // ─── Document bubble ───────────────────────────────────────────────────────

  Widget _buildDocumentBubble() {
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (docs.isNotEmpty)
          ...docs.map((doc) => Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: _buildDocItem(doc),
          ))
        else
          _buildDocItem(''),

        // Optional caption
        if (text.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
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
      onTap: docPath.isNotEmpty ? () => _openDocument(docPath) : null,
      child: Container(
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
            // File icon with extension badge
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
                    color: isMe ? Colors.white : const Color(0xff555555),
                    size: 26.sp,
                  ),
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
            // File name + hint
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    maxLines: 2,
                    text: fileName,
                    fontSize: 12,
                    color: isMe ? Colors.white : const Color(0xff222222),
                  ),
                  4.height,
                  CommonText(
                    text: docPath.isNotEmpty
                        ? 'Tap to download & open'
                        : 'File unavailable',
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
    final url = _fullUrl(avatarImage);
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

  // ─── Doc color helper ──────────────────────────────────────────────────────

  Color _docColor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'txt':
        return Colors.grey;
      default:
        return const Color(0xffFD713F);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// IMAGE VIEWER SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class _ImageViewerScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _ImageViewerScreen({
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<_ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<_ImageViewerScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.images.length > 1
              ? '${_currentIndex + 1} / ${widget.images.length}'
              : '',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: () {
              final url = widget.images[_currentIndex];
              final fileName = url.split('/').last;
              _FileDownloadHelper.downloadAndOpen(url, fileName);
            },
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.images.length,
        pageController: PageController(initialPage: widget.initialIndex),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.images[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.broken_image_outlined,
                  color: Colors.white54, size: 48),
            ),
          );
        },
        loadingBuilder: (_, __) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xffFD713F),
            strokeWidth: 2,
          ),
        ),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FILE DOWNLOAD HELPER
// ═══════════════════════════════════════════════════════════════════════════════

class _FileDownloadHelper {
  static Future<void> downloadAndOpen(String url, String fileName) async {
    try {
      Get.snackbar(
        'Downloading',
        fileName,
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.transparent,
        progressIndicatorValueColor:
        const AlwaysStoppedAnimation(Color(0xffFD713F)),
        backgroundColor: const Color(0xff222222),
        colorText: Colors.white,
        duration: const Duration(seconds: 60),
        isDismissible: false,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );

      final Directory dir;
      if (Platform.isAndroid) {
        dir = (await getExternalStorageDirectory())!;
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final savePath = '${dir.path}/$fileName';

      await Dio().download(url, savePath);

      Get.closeAllSnackbars();

      Get.snackbar(
        'Downloaded',
        'Opening $fileName…',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff4CAF50),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done) {
        Get.snackbar(
          'Cannot Open',
          result.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Error',
        'Failed to download file',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    }
  }
}