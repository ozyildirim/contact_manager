import 'dart:developer';
import 'dart:io';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class ContactService {
  static Future<void> createVcfFile(List<Contact> contacts) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      var contactsAsFile = File("$path/contacts.txt");

      var totalString = "";
      for (var element in contacts) {
        totalString += "${element.toVCard()}\n";
      }

      contactsAsFile.writeAsStringSync(totalString, mode: FileMode.write);

      var vcf = contactsAsFile
          .renameSync(contactsAsFile.path.replaceAll(".txt", ".vcf"));

      Share.shareFiles([vcf.path]);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      log(e.toString());
    }
  }
}
