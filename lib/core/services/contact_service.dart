import 'dart:developer';
import 'dart:io';

import 'package:contact_manager/core/models/duplicate_contact_model.dart';
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

  Future<void> addContacts(List<Contact> contacts) async {
    try {
      await Future.forEach(
          contacts, (element) => FlutterContacts.insertContact(element));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteContacts(List<Contact> contacts) async {
    try {
      for (var element in contacts) {
        await FlutterContacts.deleteContact(element);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      log(e.toString());
      rethrow;
    }
  }

  // ///Detect same numbers
  // Future<List<DuplicateContactModel>> getDuplicateContacts(
  //     List<Contact> contacts) async {
  //   try {
  //     List<DuplicateContactModel> duplicates = [];

  //     List<Contact> contacts = contacts.map((contact) {
  //       contact.phones.forEach((element) {
  //         element.normalizedNumber
  //       });
  //     }).toList();
  //   } catch (e) {
  //   } finally {}
  // }
}
