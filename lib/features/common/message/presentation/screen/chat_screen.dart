
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
          centerTitle: false,
          flexibleSpace: appBarOpacity(),
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
                  child: CommonTextField(
                    hintText: AppString.search,
                    keyboardType: TextInputType.text,
                    borderRadius: 30,
                    fillColor: Color(0xffFAFAFA).withValues(alpha: 0.7),
                    borderColor: Colors.grey.withValues(alpha: 0.3),

                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Icon(CupertinoIcons.search),
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
            EdgeInsets.symmetric(horizontal: 16.w,vertical: 20.h),
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
