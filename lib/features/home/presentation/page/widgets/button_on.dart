import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonOn extends StatefulWidget {
  final String name;
  final VoidCallback? function;
  final bool isEnabled;
  final bool isPressed;
  final double? width;
  final double? height;

  const ButtonOn({
    super.key,
    required this.name,
    required this.function,
    required this.isEnabled,
    required this.isPressed,
    this.width,
    this.height,
  });

  @override
  State<ButtonOn> createState() => _ButtonOnState();
}

class _ButtonOnState extends State<ButtonOn> {
  bool _isLocalPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isLocalPressed = true),
      onTapUp: (_) => setState(() => _isLocalPressed = false),
      onTapCancel: () => setState(() => _isLocalPressed = false),
      onTap: widget.isEnabled ? widget.function : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width ?? double.infinity,
        height: widget.height ?? 45.h,
        transform: Matrix4.identity()..scale(_isLocalPressed ? 0.96 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: widget.isEnabled && !_isLocalPressed ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : null,
          border: Border.all(
            color: widget.isEnabled
                ? (widget.isPressed || _isLocalPressed ? Colors.blue.shade900 : Colors.blue.shade500)
                : Colors.grey.shade400,
            width: 1.5.w,
          ),
          color: widget.isEnabled
              ? (widget.isPressed || _isLocalPressed ? Colors.blue.shade100 : Colors.white)
              : Colors.grey.shade200,
        ),
        child: Center(
          child: Text(
            widget.name,
            style: TextStyle(
              fontSize: 16.sp,
              color: widget.isEnabled
                  ? (widget.isPressed || _isLocalPressed ? Colors.blue.shade900 : Colors.blue.shade500)
                  : Colors.grey.shade500,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
