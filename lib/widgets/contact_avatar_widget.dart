import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_contacts/contact.dart';

class ContactAvatarWidget extends StatelessWidget {
  final Contact contact;
  const ContactAvatarWidget({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    String letters = contact.displayName.split(" ").map<String>((element) {
      return element[0];
    }).join("");
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.grey,
      child: Center(
        child: Text(
          letters,
          style: const TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
