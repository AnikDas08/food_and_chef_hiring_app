import 'package:flutter/material.dart';
import 'package:new_untitled/component/bottom_nav_bar/chef_bottom_bar.dart';
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
      appBar: AppBar(
        title: CommonText(
          text: AppString.analytics,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [earning(), BookTime(), bookInfo(), topItem()]),
      ),
    );
  }
}
