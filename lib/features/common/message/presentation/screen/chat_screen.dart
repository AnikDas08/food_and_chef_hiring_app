
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/other_widgets/common_loader.dart';
import '../../../../../component/screen/error_screen.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../controller/chat_controller.dart';
import '../../data/model/chat_list_model.dart';
import '../../../../../../utils/enum/enum.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../widgets/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,

      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        flexibleSpace: LiquidGlassLayer(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.05),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const CommonText(
          text: AppString.chat,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: LiquidGlassLayer(
              child: LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: 30.r),
                child: GetBuilder<ChatController>(
                  builder: (controller) => CommonTextField(
                    controller: controller.searchControllers,
                    hintText: "Search",
                    keyboardType: TextInputType.text,
                    borderRadius: 30,
                    fillColor: Color(0xffF5F5F5),
                    borderColor: Colors.transparent,
                    onChanged: controller.searchChats,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Icon(
                        CupertinoIcons.search,
                        color: Color(0xff636363),
                        size: 23.sp,
                      ),
                    ),
                    // ── Filter icon with divider ──
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 1,
                          height: 22.h,
                          color: Color(0xffE0E0E0),
                        ),
                        SizedBox(width: 12.w),
                        Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: CommonImage(
                            imageSrc: AppIcons.fliter,
                            imageColor: Color(0xff636363),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      /// Body Section
      body: GetBuilder<ChatController>(
        builder: (controller) => switch (controller.status) {
        /// Loading
          Status.loading => const CommonLoader(),

        /// Error
          Status.error => ErrorScreen(
            onTap: ChatController.instance.getChatRepo,
          ),

        /// Data
          Status.completed => (controller.filteredChats.isEmpty || controller.filteredChats.isEmpty)
              ? _buildEmptyState(): Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView(
              padding: EdgeInsets.fromLTRB(0, 150.h, 0, 100.h),
              controller: controller.scrollController,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredChats.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    ChatModel item = controller.filteredChats[index];
                    return InkWell(
                      onTap: () => Get.toNamed(
                        AppRoutes.message,
                        parameters: {
                          "chatId": item.id,
                          "name": item.participant.fullName,
                          "image": item.participant.image,
                        },
                      ),
                      child: chatListItem(item: item),
                    );
                  },
                ),
              ],
            ),
          ),
        },
      ),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.chat_bubble_text,
            size: 80.sp,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16.h),
          CommonText(
            text: "No chats found",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
          SizedBox(height: 8.h),
          CommonText(
            text: "Start a conversation to see them here.",
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
