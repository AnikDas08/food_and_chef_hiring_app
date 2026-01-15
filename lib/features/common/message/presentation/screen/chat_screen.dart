import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../component/image/common_image.dart';
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.white.withOpacity(0.1)),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CommonTextField(
              hintText: AppString.search,
              keyboardType: TextInputType.none,
              onTap: () => Get.toNamed(AppRoutes.homeSearch),
              borderRadius: 20,
              fillColor: Color(0xffFAFAFA),
              suffixIcon: Padding(
                padding: EdgeInsets.all(10),
                child: CommonImage(
                  imageSrc: AppIcons.fliter,
                  imageColor: Color(0xff636363),
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(CupertinoIcons.search),
              ),
            ),
          ),
        ),
      ),

      /// Body Section Starts here
      body: GetBuilder<ChatController>(
        builder:
            (controller) => switch (controller.status) {
              /// Loading bar here
              Status.loading => const CommonLoader(),

              /// Error Handle here
              Status.error => ErrorScreen(
                onTap: ChatController.instance.getChatRepo,
              ),

              /// Show main data here
              Status.completed => Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: ListView(
                  children: [
                    /// User Search bar here

                    /// Show all Chat List here
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.chats.length,
                      padding: EdgeInsets.only(bottom: 80.h, top: 16.h),

                      itemBuilder: (context, index) {
                        ChatModel item = controller.chats[index];
                        return InkWell(
                          /// routing with data
                          onTap:
                              () => Get.toNamed(
                                AppRoutes.message,
                                parameters: {
                                  "chatId": item.id,
                                  "name": item.participant.fullName,
                                  "image": item.participant.image,
                                },
                              ),

                          /// Chat List item here
                          child: chatListItem(item: controller.chats[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            },
      ),

      /// Bottom Navigation Bar Section Starts here
      // bottomNavigationBar:
      //     LocalStorage.isChef
      //         ? ChefBottomBar(currentIndex: 3)
      //         : const CommonBottomNavBar(currentIndex: 3),
    );
  }
}
