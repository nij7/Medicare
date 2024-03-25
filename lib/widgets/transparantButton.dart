
import 'package:flutter/material.dart';

class TransparantButton extends StatelessWidget {
  const TransparantButton({Key? key, required this.onTap, required this.child})
      : super(key: key);

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(0),
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      color: Colors.transparent,
      highlightColor: Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      onPressed: onTap,
      child: child,
    );
  }
}
