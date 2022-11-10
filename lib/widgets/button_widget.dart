import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final Color? textColor;
  const ButtonWidget(
      {super.key,
      required this.title,
      this.backgroundColor,
      this.textColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 10,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black,
        ),
      ),
    );
  }
}
