import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final Widget child;
  final Widget dropdown;
  final double dropdownHeight;

  const CustomDropdown({
    super.key,
    required this.child,
    required this.dropdown,
    this.dropdownHeight = 180,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggle() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _remove();
    }
  }

  void _remove() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: _remove,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                Positioned(
                  width: MediaQuery.of(context).size.width - 32,
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    offset: const Offset(0, 8),
                    child: Material(
                      color: Colors.transparent,
                      child: widget.dropdown,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(onTap: _toggle, child: widget.child),
    );
  }
}
