import 'dart:developer';

import 'package:contact_manager/core/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ViewState { Ideal, Busy }

class ContactProvider with ChangeNotifier {
  ViewState state = ViewState.Ideal;
  ContactService contactService = ContactService();

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
        return contacts;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      changeViewState(ViewState.Ideal);
    }
  }

  Future<void> addContacts(List<Contact> contacts) async {
    try {
      changeViewState(ViewState.Busy);
      contactService.addContacts(contacts);
    } catch (e) {
      log(e.toString());
    } finally {
      changeViewState(ViewState.Ideal);
    }
  }
}
