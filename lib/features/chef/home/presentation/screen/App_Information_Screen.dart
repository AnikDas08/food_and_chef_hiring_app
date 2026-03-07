import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInformationScreen extends StatefulWidget {
  const AppInformationScreen({super.key});

  @override
  State<AppInformationScreen> createState() => _AppInformationScreenState();
}

class _AppInformationScreenState extends State<AppInformationScreen>
    with TickerProviderStateMixin {
  PackageInfo? _packageInfo;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late List<AnimationController> _itemControllers;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<_InfoItem> _items = [];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _itemControllers = List.generate(
      4,
          (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      _items.addAll([
        _InfoItem(
          icon: Icons.apps_rounded,
          label: 'App Name',
          value: info.appName,
          gradient: const [Color(0xFF0288A6), Color(0xFF00BCD4)],
        ),
        _InfoItem(
          icon: Icons.rocket_launch_rounded,
          label: 'Version',
          value: info.version,
          gradient: const [Color(0xFF1B5E20), Color(0xFF43A047)],
        ),
        _InfoItem(
          icon: Icons.tag_rounded,
          label: 'Build Number',
          value: info.buildNumber,
          gradient: const [Color(0xFF4A148C), Color(0xFF7B1FA2)],
        ),
        _InfoItem(
          icon: Icons.inventory_2_rounded,
          label: 'Package Name',
          value: info.packageName,
          gradient: const [Color(0xFFBF360C), Color(0xFFE64A19)],
        ),
      ]);
    });

    _fadeController.forward();
    _slideController.forward();

    for (int i = 0; i < _itemControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 80 * i));
      _itemControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E1A),
        body: CustomScrollView(
          slivers: [
            _buildSliverHeader(),
            SliverToBoxAdapter(
              child: _packageInfo == null
                  ? SizedBox(
                height: 300.h,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0288A6),
                    strokeWidth: 2,
                  ),
                ),
              )
                  : FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 40.h),
                    child: Column(
                      children: [
                        _buildAppTitle(),
                        SizedBox(height: 32.h),
                        _buildItemsGrid(),
                        SizedBox(height: 32.h),
                        _buildDivider(),
                        SizedBox(height: 28.h),
                        _buildCopyright(),
                      ],
                    ),
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
      expandedHeight: 260.h,
      pinned: true,
      backgroundColor: const Color(0xFF0A0E1A),
      leading: GestureDetector(
        onTap: Get.back,
        child: Container(
          margin: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Deep dark gradient bg
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF051822),
                    Color(0xFF083E4B),
                    Color(0xFF0A0E1A),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
            ),

            // Glow orb - top right
            Positioned(
              top: -40.h,
              right: -40.w,
              child: Container(
                width: 200.r,
                height: 200.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF0288A6).withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Glow orb - bottom left
            Positioned(
              bottom: 10.h,
              left: -30.w,
              child: Container(
                width: 150.r,
                height: 150.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF074E5E).withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Grid lines (subtle)
            CustomPaint(
              painter: _GridPainter(),
            ),

            // Center logo
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),
                  // Outer glow ring
                  Container(
                    width: 110.r,
                    height: 110.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF0288A6).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Center(
                      // Inner logo container
                      child: Container(
                        width: 86.r,
                        height: 86.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF0288A6),
                              Color(0xFF074E5E),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0288A6).withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.work_rounded,
                          color: Colors.white,
                          size: 40.r,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF0288A6).withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      color: const Color(0xFF0288A6).withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF00E5FF),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        title: Text(
          'App Info',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildAppTitle() {
    return Column(
      children: [
        Text(
          _packageInfo?.appName ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _versionChip(
              'v${_packageInfo?.version}',
              const Color(0xFF0288A6),
            ),
            SizedBox(width: 8.w),
            _versionChip(
              'Build ${_packageInfo?.buildNumber}',
              const Color(0xFF6A1B9A),
            ),
          ],
        ),
      ],
    );
  }

  Widget _versionChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: color.withOpacity(0.9),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildItemsGrid() {
    return Column(
      children: _items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _itemControllers[i],
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: _itemControllers[i],
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  children: [
                    // Icon with gradient bg
                    Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: item.gradient,
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        color: Colors.white,
                        size: 22.r,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white.withOpacity(0.35),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.value.isEmpty ? 'N/A' : item.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Accent dot
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: item.gradient,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: 4.r,
            height: 4.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyright() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.copyright_rounded,
              size: 13.r,
              color: Colors.white.withOpacity(0.25),
            ),
            SizedBox(width: 5.w),
            Text(
              '${DateTime.now().year} ${_packageInfo?.appName ?? 'JobsInApp'}. All rights reserved.',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withOpacity(0.25),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          'Made with ❤️ for job seekers',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}

// Subtle background grid painter
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> gradient;

  _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });
}