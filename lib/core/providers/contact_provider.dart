import 'dart:developer';

import 'package:contact_manager/core/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../../widgets/contact_avatar_widget.dart';

enum ViewState { Ideal, Busy }

class ContactProvider with ChangeNotifier {
  ViewState state = ViewState.Ideal;
  ContactService contactService = ContactService();

  Logger logger = Logger();

  List<Contact>? contacts;

  changeViewState(ViewState state, {bool isNotify = true}) {
    this.state = state;
    if (isNotify) {
      notifyListeners();
      return;
    }
  }

  Future<List<Contact>?> fetchContacts() async {
    try {
      if (!await FlutterContacts.requestPermission(readonly: true)) {
        Fluttertoast.showToast(msg: "Request Denied");
        return null;
      } else {
        changeViewState(ViewState.Busy);
        contacts = await FlutterContacts.getContacts(
            withThumbnail: true, withProperties: true);
        contacts!.forEach((element) {
          print(element);
        });
        return contacts;
      }
    } catch (e) {
      log(e.toString());
      return null;
    } finally {
      changeViewState(ViewState.Ideal);
    }
  }

  Future<void> addContacts(List<Contact> contacts) async {
    try {
      await changeViewState(ViewState.Busy);
      contactService.addContacts(contacts);
      logger.i("Added Contacts: ${contacts.toList().toString()}");
      await fetchContacts();
    } catch (e) {
      log(e.toString());
    } finally {
      changeViewState(ViewState.Ideal);
    }
  }

  Future<void> deleteContacts(List<Contact> contacts) async {
    try {
      changeViewState(ViewState.Busy);
      await contactService.deleteContacts(contacts);
      logger.i("Deleted Contacts: ${contacts.toList().toString()}");
      await fetchContacts();
    } catch (e) {
      log(e.toString());
    } finally {
      changeViewState(ViewState.Ideal);
    }
  }

  Widget? getContactPicture(Contact contact) {
    if (contact.photoOrThumbnail != null &&
        contact.photoOrThumbnail!.isNotEmpty) {
      return CircleAvatar(
          backgroundImage: MemoryImage(contact.photoOrThumbnail!));
    }
    return ContactAvatarWidget(contact: contact);
  }

  Widget? getContactItemSubtitle(Contact item) {
    try {
      var phoneNumber = item.phones.first.number;
      return Text(phoneNumber);
    } catch (e) {
      return null;
    }
  }
}
