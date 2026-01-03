import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopupController {
  static final PopupController _instance = PopupController._internal();

  factory PopupController() => _instance;

  PopupController._internal();

  OverlayEntry? _entry;

  void show(
    BuildContext context,
    Offset position,
    List<String> list,
    Function(String)? onTap,
  ) {
    if (_entry != null) return; // already open
    final overlay = Overlay.of(context, rootOverlay: true);
    _entry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: position.dx,
            bottom: position.dy,
            child: _PopupMenu(onClose: hide, list: list, onTap: onTap),
          ),
    );

    Overlay.of(context).insert(_entry!);
  }

  void showAdd(
    BuildContext context, {
    double? top,
    double? right,
    double? left,
    double? bottom,
    String selectItem = "",
    required List<String> list,
    Function(String)? onTap,
  }) {
    if (_entry != null) return; // already open

    final overlay = Overlay.of(context, rootOverlay: true);

    _entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: top,
          right: right,
          left: left,
          bottom: bottom,
          child: _PopupMenu(
            onClose: hide,
            list: list,
            onTap: onTap,
            selectItem: selectItem,
          ),
        );
      },
    );

    overlay.insert(_entry!);
  }

  /* <<<<<<<<<<<<<<  ✨ Windsurf Command ⭐ >>>>>>>>>>>>>>>> */

  /// Removes the current overlay entry from the overlay.
  /// If no overlay entry exists, this is a no-op.
  ///
  /// This function is typically called when the user is done
  /// interacting with the popup menu.
  /* <<<<<<<<<<  7f01f1c8-8b39-47e0-b564-66b60f1f5b4e  >>>>>>>>>>> */
  void hide() {
    _entry?.remove();
    _entry = null;
  }

  bool get isVisible => _entry != null;
}

class _PopupMenu extends StatelessWidget {
  final VoidCallback onClose;
  final Function(String)? onTap;
  final List<String> list;
  final String selectItem;

  const _PopupMenu({
    required this.onClose,
    required this.list,
    this.onTap,
    this.selectItem = "",
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xffF1F1F1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: list.length + 1,
            padding: EdgeInsets.zero,

            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                  onTap: () {
                    onTap?.call(list[index]);
                    onClose();
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        margin: EdgeInsets.only(right: 4, bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xffF1F1F1)),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "30",
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 0,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xffF1F1F1)),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                list[index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down_sharp),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              String value = list[index - 1];
              return InkWell(
                onTap: () {
                  onTap?.call(value);
                  onClose();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(index == 1 ? 8 : 0),
                      topLeft: Radius.circular(index == 1 ? 8 : 0),
                      bottomLeft: Radius.circular(index == 2 ? 8 : 0),
                      bottomRight: Radius.circular(index == 2 ? 8 : 0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        width: 15.sp,
                        height: 15.sp,
                        decoration: BoxDecoration(
                          color:
                              selectItem == value
                                  ? Color(0xff272727)
                                  : Color(0xffF1F1F1),
                          shape: BoxShape.circle,
                        ),
                        child:
                            selectItem != value
                                ? null
                                : Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 10,
                                ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
