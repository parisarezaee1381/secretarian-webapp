import 'package:flutter/material.dart';
import 'hoverablecontainer.dart';
import 'package:flutter_application_1/dashboard.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.icon,
    this.iconColor = const Color(0xFF3863A8),
    this.size = 32,
    this.touchTargetSize,
    this.hoverBackgroundColor = const Color(0xFF828288),
    this.hoverBackgroundOpacity = 0.5,
    this.borderRadius = 10,
    this.isDisabled = false,
    this.semanticLabel = 'بازگشت',
  });

  final VoidCallback? onPressed;

  final IconData? icon;
  final Color iconColor;
  final double size;
  final double? touchTargetSize;
  final Color hoverBackgroundColor;
  final double hoverBackgroundOpacity;
  final double borderRadius;
  final bool isDisabled;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveTouchSize = touchTargetSize ?? (size < 44 ? 44 : size);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final resolvedIcon =
        icon ?? (isRtl ? Icons.arrow_forward : Icons.arrow_back);

    return HoverableContainer(
      width: effectiveTouchSize,
      height: effectiveTouchSize,
      borderRadius: borderRadius,
      hoverColor: hoverBackgroundColor,
      hoverOpacity: hoverBackgroundOpacity,
      isDisabled: isDisabled,
      semanticLabel: semanticLabel,
      onTap:
          onPressed ??
          () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Dashboard()),
              (route) => false,
            );
          },
      child: Center(
        child: Icon(resolvedIcon, color: iconColor, size: size),
      ),
    );
  }
}
