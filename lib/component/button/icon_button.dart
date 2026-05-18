import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';
import '../text/common_text.dart';

class CustomButtonIcon extends StatefulWidget {
  final VoidCallback? onTap;
  final String titleText;
  final Color titleColor;
  final Color buttonColor;
  final Color? borderColor;
  final double borderWidth;
  final double titleSize;
  final FontWeight titleWeight;
  final double buttonRadius;
  final double buttonHeight;
  final double buttonWidth;
  final bool isLoading;
  final String? prefixImage;
  final BoxFit imageFit;

  // NEW
  final IconData? prefixIcon;
  final String? prefixSvg;
  final double iconSize;
  final Color? iconColor;
  final double spacing;

  const CustomButtonIcon({
    this.onTap,
    required this.titleText,
    this.titleColor = AppColors.white,
    this.buttonColor = AppColors.primaryColor,
    this.titleSize = 14,
    this.buttonRadius = 20,
    this.titleWeight = FontWeight.w500,
    this.buttonHeight = 60,
    this.borderWidth = 1,
    this.isLoading = false,
    this.buttonWidth = double.infinity,
    this.borderColor = AppColors.transparent,

    // NEW
    this.prefixIcon,
    this.prefixSvg,
    this.iconSize = 28,
    this.iconColor,
    this.spacing = 8,

    this.prefixImage,
    this.imageFit = BoxFit.contain,

    super.key,
  });

  @override
  State<CustomButtonIcon> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CustomButtonIcon>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      upperBound: 0.15,
    )..addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.buttonHeight,
      width: widget.buttonWidth,
      child: _buildElevatedButton(),
    );
  }

  Widget _buildElevatedButton() {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: Transform.scale(
        scale: (1 - _animationController.value).toDouble(),
        child: ElevatedButton(
          onPressed: null,
          style: _buttonStyle(),
          child: widget.isLoading
              ? _buildLoader()
              : _buildButtonContent(),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      backgroundColor:
      WidgetStateProperty.all(widget.buttonColor),
      foregroundColor:
      WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor:
      WidgetStateProperty.all(Colors.transparent),
      overlayColor:
      WidgetStateProperty.all(Colors.transparent),
      shadowColor:
      WidgetStateProperty.all(Colors.transparent),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(widget.buttonRadius),
          side: BorderSide(
            color:
            widget.borderColor ?? Colors.transparent,
            width: widget.borderWidth,
          ),
        ),
      ),
      elevation: WidgetStateProperty.all(0),
    );
  }

  Widget _buildLoader() {
    return Center(
      child: CupertinoActivityIndicator(
        color: widget.titleColor,
      ),
    );
  }

  Widget _buildButtonContent() {
    final bool hasWidget =
        widget.prefixIcon != null ||
            (widget.prefixSvg?.isNotEmpty ?? false) ||
            (widget.prefixImage?.isNotEmpty ?? false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon
        if (widget.prefixIcon != null)
          Icon(
            widget.prefixIcon,
            size: widget.iconSize,
            color: widget.iconColor ??
                widget.titleColor,
          ),

        // SVG
        if (widget.prefixSvg != null &&
            widget.prefixSvg!.isNotEmpty)
          SvgPicture.asset(
            widget.prefixSvg!,
            width: widget.iconSize,
            height: widget.iconSize,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              widget.iconColor ??
                  widget.titleColor,
              BlendMode.srcIn,
            ),
          ),

        // Normal Image (asset or network)
        if (widget.prefixImage != null &&
            widget.prefixImage!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: widget.prefixImage!.startsWith('http')
                ? Image.network(
              widget.prefixImage!,
              width: widget.iconSize,
              height: widget.iconSize,
              fit: widget.imageFit,
            )
                : Image.asset(
              widget.prefixImage!,
              width: widget.iconSize,
              height: widget.iconSize,
              fit: widget.imageFit,
            ),
          ),

        if (hasWidget)
          SizedBox(width: widget.spacing),

        CommonText(
          text: widget.titleText,
          height: 1.3,
          fontSize: widget.titleSize,
          color: widget.titleColor,
          fontWeight: widget.titleWeight,
        ),
      ],
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap == null) return;
    _animationController.reverse();
  }

  void _onTapCancel() {
    if (widget.onTap == null) return;
    _animationController.reverse();
  }
}