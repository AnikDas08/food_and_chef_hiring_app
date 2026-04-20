import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

import '../widgets/book_info.dart';
import '../widgets/book_time.dart';
import '../widgets/earning.dart';
import '../widgets/top_item.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: false,
        backgroundColor: Colors.transparent,
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
          text: AppString.analytics,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [earning(), BookTime(), bookInfo(), topItem()],
        ),
      ),
    );
  }
}