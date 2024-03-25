import 'package:bcrud/core/appColors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.child,
    required this.onPressed,
    this.bg = AppColors.primary,
    this.fg = AppColors.secondary,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget? child;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    return MaterialButton(
      onPressed: onPressed,
      height: mq * 0.15,
      minWidth: mq * 0.9,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mq * 0.05)),
      color: bg,
      child: child ?? Text('LOGIN', style: TextStyle(color: fg)),
    );
  }
}
