import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

import '../../../../../component/other_widgets/app_bar_opacity.dart';
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
        flexibleSpace: appBarOpacity(),
        title: CommonText(
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
