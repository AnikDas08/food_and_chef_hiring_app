import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class AppInformationScreen extends StatefulWidget {
  const AppInformationScreen({super.key});

  @override
  State<AppInformationScreen> createState() => _AppInformationScreenState();
}

class _AppInformationScreenState extends State<AppInformationScreen>
    with TickerProviderStateMixin {
  PackageInfo? _packageInfo;
  String _deviceModel = '';
  String _osVersion = '';
  String _platform = '';

  late AnimationController _heroController;
  late List<AnimationController> _itemControllers;
  late Animation<double> _heroAnim;

  final List<_InfoItem> _items = [];

  // ── Brand colors ──
  static const _primary = Color(0xFFE82535);
  static const _secondary = Color(0xFF0076BF);
  static const _bg = Color(0xFFFAF7F4);
  static const _card = Colors.white;
  static const _dark = Color(0xFF1A0A00);

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _heroAnim =
        CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic);

    _itemControllers = List.generate(
      6,
          (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 380),
      ),
    );

    _loadAllInfo();
  }

  Future<void> _loadAllInfo() async {
    final info = await PackageInfo.fromPlatform();

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      _deviceModel = '${android.manufacturer} ${android.model}';
      _osVersion = 'Android ${android.version.release}';
      _platform = 'Android';
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      _deviceModel = ios.model;
      _osVersion = 'iOS ${ios.systemVersion}';
      _platform = 'iOS';
    }

    setState(() {
      _packageInfo = info;
      _items.addAll([
        _InfoItem(
          icon: Icons.restaurant_rounded,
          label: 'App Name',
          value: info.appName,
          color: _primary,
        ),
        _InfoItem(
          icon: Icons.new_releases_rounded,
          label: 'Version',
          value: info.version,
          color: const Color(0xFF0076BF),
        ),

        _InfoItem(
          icon: Platform.isIOS
              ? Icons.phone_iphone_rounded
              : Icons.phone_android_rounded,
          label: 'Device Model',
          value: _deviceModel,
          color: const Color(0xFF0076BF),
        ),
        _InfoItem(
          icon: Icons.system_update_rounded,
          label: 'OS Version',
          value: _osVersion,
          color: const Color(0xFF0076BF),
        ),
      ]);
    });

    _heroController.forward();
    for (int i = 0; i < _itemControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 90 * i));
      if (mounted) _itemControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _heroController.dispose();
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _bg,
        body: CustomScrollView(
          slivers: [
            _buildSliverHeader(),
            SliverToBoxAdapter(
              child: _packageInfo == null
                  ? SizedBox(
                height: 300.h,
                child: const Center(
                  child: CircularProgressIndicator(color: _primary),
                ),
              )
                  : FadeTransition(
                opacity: _heroAnim,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 48.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppNameRow(),
                      SizedBox(height: 20.h),
                      _buildDeviceBadge(),
                      SizedBox(height: 28.h),
                      _buildSectionLabel('APP DETAILS'),
                      SizedBox(height: 12.h),
                      _buildItemsList(),
                      SizedBox(height: 32.h),
                      _buildCopyright(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 240.h,
      pinned: true,
      backgroundColor: _primary,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: GestureDetector(
        onTap: Get.back,
        child: Container(
          margin: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'App Information',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient bg
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF259DE8),
                    Color(0xADA4FF35),
                    Color(0xFF0076BF),
                  ],
                ),
              ),
            ),

            // Decorative circles
            Positioned(
              top: -30.h,
              right: -30.w,
              child: Container(
                width: 180.r,
                height: 180.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -20.h,
              left: -20.w,
              child: Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              top: 50.h,
              left: 30.w,
              child: Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            // Center logo
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    width: 90.r,
                    height: 90.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '🍳',
                        style: TextStyle(fontSize: 38.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppNameRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: _primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: _primary.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7.r,
                height: 7.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF22C55E),
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                'LIVE',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: _primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceBadge() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              _platform == 'iOS'
                  ? Icons.phone_iphone_rounded
                  : Icons.phone_android_rounded,
              color: _primary,
              size: 22.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RUNNING ON',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '$_platform  ·  $_deviceModel',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: _dark,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[500],
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isLast = i == _items.length - 1;

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _itemControllers[i],
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(
              opacity: _itemControllers[i],
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 14.h),
                    child: Row(
                      children: [
                        Container(
                          width: 42.r,
                          height: 42.r,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(item.icon,
                              color: item.color, size: 20.r),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                item.value.isEmpty ? 'N/A' : item.value,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: _dark,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.color.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 72.w,
                      endIndent: 16.w,
                      color: Colors.grey[100],
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCopyright() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.copyright_rounded,
                size: 13.r, color: Colors.grey[400]),
            SizedBox(width: 4.w),

            Text(
              'Made with ❤️ for food lovers',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[400],
              ),
            ),

          ],
        ),
      ],
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}