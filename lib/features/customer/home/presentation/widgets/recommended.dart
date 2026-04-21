// widgets/recommended.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/home_controller.dart';
import 'chef_item.dart';

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder:
          (_, __) => Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Color(0xffE0E0E0).withOpacity(_animation.value),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
    );
  }
}

Widget _chefShimmerCard() {
  return Container(
    margin: const EdgeInsets.only(right: 12),
    width: 240,
    decoration: BoxDecoration(
      color: const Color(0xffF2F2F2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image placeholder
        _ShimmerBox(width: 240, height: 200, borderRadius: 10),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ShimmerBox(width: 120, height: 12),
                  _ShimmerBox(width: 40, height: 12),
                ],
              ),
              const SizedBox(height: 8),
              _ShimmerBox(width: 160, height: 12),
              const SizedBox(height: 16),
              _ShimmerBox(width: 80, height: 14),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget recommended() {
  return GetBuilder<HomeController>(
    builder: (controller) {
      // Smooth shimmer while loading location or chefs
      if (controller.isLoadingLocation || controller.isLoadingChefs) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (_, __) => _chefShimmerCard(),
        );
      }

      // No chefs found
      if (controller.nearbyChefsList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              /*Text(
                'No nearby chefs found',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),*/
              CommonText(
                text: "No nearby chefs found",
                fontSize: 12,
                color: Color(0xff777777),
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => controller.refreshChefs(),
                child: /*Text(
                  'Retry',
                  style: TextStyle(
                    color: Color(0xffFD713F),
                    fontWeight: FontWeight.w600,
                  ),
                ),*/ CommonText(
                  text: "Retry",
                  fontSize: 12,
                  color: Color(0xff272727),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      // Animate list in smoothly
      return ListView.builder(
        itemCount: controller.nearbyChefsList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 80)),
            curve: Curves.easeOut,
            builder:
                (_, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(20 * (1 - value), 0),
                    child: child,
                  ),
                ),
            child: chefItem(chef: controller.nearbyChefsList[index]),
          );
        },
      );
    },
  );
}
