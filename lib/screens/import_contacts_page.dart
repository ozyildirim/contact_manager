import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/vcard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/contact_avatar_widget.dart';

class ImportContactsPage extends StatefulWidget {
  const ImportContactsPage({super.key});

  @override
  State<ImportContactsPage> createState() => _ImportContactsPageState();
}

class _ImportContactsPageState extends State<ImportContactsPage> {
  bool isSelectionMode = false;

  List<Contact>? fetchedContacts;
  List<Contact> selectedContacts = [];

  @override
  void initState() {
    super.initState();
    selectedContacts.clear();
    Future.delayed(const Duration(milliseconds: 500), showImportSourceDialog);
  }

  get isSelectedAll {
    return selectedContacts.length == fetchedContacts!.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: leadingActionButton,
        leadingWidth: 64,
        title: Text((selectedContacts.isNotEmpty)
            ? "${selectedContacts.length} Contact Selected"
            : "Import Contacts"),
        actions: [actionButton],
      ),
      body: Container(
        child: fetchedContacts != null && fetchedContacts!.isNotEmpty
            ? ListView.builder(
                itemCount: fetchedContacts!.length + 1,
                itemBuilder: ((context, index) {
                  if (index == 0) {
                    if (isSelectionMode) {
                      return ListTile(
                        title: Text(
                          isSelectedAll ? "Unselect All" : "Select All",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: isSelectedAll
                            ? unselectAllContacts
                            : selectAllContacts,
                      );
                    }
                    return Container();
                  } else {
                    var item = fetchedContacts![index - 1];
                    return ListTile(
                      trailing: getContactPicture(item),
                      title: Text(item.displayName),
                      subtitle: getContactItemSubtitle(item),
                      onTap: () => toggleContactItem(item),
                      leading: isSelectionMode
                          ? selectedContacts.contains(item)
                              ? const Icon(
                                  CupertinoIcons.check_mark_circled_solid,
                                  color: Colors.black,
                                )
                              : const Icon(CupertinoIcons.circle)
                          : null,
                    );
                  }
                }),
              )
            : Container(),
      ),
    );
  }

  selectAllContacts() {
    for (var element in fetchedContacts!) {
      if (selectedContacts.any((selectedElement) =>
          selectedElement.phones.first == element.phones.first)) {
        return;
      }
      setState(() {
        selectedContacts.add(element);
      });
    }
  }

  unselectAllContacts() {
    setState(() {
      selectedContacts.clear();
    });
  }

  void toggleContactItem(Contact contact) {
    if (isSelectionMode) {
      setState(() {
        if (selectedContacts.contains(contact)) {
          selectedContacts.remove(contact);
        } else {
          selectedContacts.add(contact);
        }
      });
    }
  }

  showImportSourceDialog() {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (context) => BottomSheetWidget());
  }

  Widget BottomSheetWidget() {
    return SafeArea(
      bottom: true,
      child: BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (context) {
            return Wrap(
              children: <Widget>[
                const ListTile(
                    title: Text(
                      'Select Import Source',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    onTap: null),
                const Divider(),
                ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.pink,
                      child: Icon(
                        FontAwesomeIcons.fileCode,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text('Pick VCF File'),
                    onTap: getVcfFromFile),
                const Divider(),
                const ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        FontAwesomeIcons.googleDrive,
                        color: Colors.white,
                      ),
                    ),
                    /*  */
                    title: Text('Import from Google Drive'),
                    subtitle: Text('Coming Soon'),
                    onTap: null),
                const Divider(),
                ListTile(
                  title: const Text('Vazgeç',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.red)),
                  onTap: () => {Navigator.pop(context)},
                ),
              ],
            );
          }),
    );
  }

  getVcfFromFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          dialogTitle: "Select VCF File",
          allowMultiple: false,
          allowedExtensions: ["vcf"]);

      if (result != null && result.count > 0) {
        File newFile = File(result.files.single.path!);
        List<String> splittedVCard =
            newFile.readAsStringSync().split("END:VCARD");
        splittedVCard.removeLast();
        fetchedContacts =
            splittedVCard.map((element) => Contact.fromVCard(element)).toList();
        setState(() {});
      }
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  get leadingActionButton {
    if (isSelectionMode) {
      return TextButton(
          onPressed: () => changeMode(), child: const Text("Cancel"));
    } else {
      return const BackButton();
    }
  }

  get actionButton {
    if (isSelectionMode) {
      if (selectedContacts.isNotEmpty) {
        return TextButton(
            onPressed: () => showImportSourceDialog(),
            child: const Text("Actions"));
      } else {
        return Container();
      }
    } else if (fetchedContacts != null && fetchedContacts!.isNotEmpty) {
      return TextButton(onPressed: changeMode, child: const Text("Select"));
    } else {
      return Container();
    }
  }

  void changeMode() {
    setState(() {
      if (isSelectionMode) {
        selectedContacts.clear();
      }
      isSelectionMode = !isSelectionMode;
    });
  }

  Widget? getContactItemSubtitle(Contact item) {
    try {
      var phoneNumber = item.phones.first.number;
      return Text(phoneNumber);
    } catch (e) {
      return null;
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
}
