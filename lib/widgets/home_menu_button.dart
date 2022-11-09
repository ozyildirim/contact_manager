import 'package:contact_manager/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class HomeMenuButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  final IconData icon;

  const HomeMenuButton(
      {super.key,
      required this.title,
      required this.callback,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          color: homeMenuButtonColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: 34),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
