import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:contact_manager/core/providers/contact_provider.dart';
import 'package:contact_manager/screens/landing_page.dart';
import 'package:contact_manager/widgets/bottom_sheet_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/vcard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../widgets/contact_avatar_widget.dart';

class ImportContactsPage extends StatefulWidget {
  const ImportContactsPage({super.key});

  @override
  State<ImportContactsPage> createState() => _ImportContactsPageState();
}

class _ImportContactsPageState extends State<ImportContactsPage> {
  late ContactProvider contactProvider;
  bool isSelectionMode = false;

  List<Contact>? fetchedContacts;
  List<Contact> selectedContacts = [];

  @override
  void initState() {
    super.initState();
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
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
                      trailing: contactProvider.getContactPicture(item),
                      title: Text(item.displayName),
                      subtitle: contactProvider.getContactItemSubtitle(item),
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
        builder: (context) => CustomModalSheetWidget(
              sheetTitle: "Select Import Source",
              sheetItems: [
                ModalSheetItem(
                  title: "Pick VCF File",
                  icon: FontAwesomeIcons.fileCode,
                  onTap: getVcfFromFile,
                ),
                ModalSheetItem(
                  title: "Import from Google Drive",
                  icon: FontAwesomeIcons.googleDrive,
                  subtitle: "Coming Soon",
                  onTap: null,
                ),
              ],
            ));
  }

  showImportActionDialog() {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (context) => CustomModalSheetWidget(
        sheetTitle: "Select Action",
        sheetItems: [
          ModalSheetItem(
            title: "Add Contacts to Phone",
            icon: FontAwesomeIcons.fileCode,
            onTap: addContactsToPhone,
          )
        ],
      ),
    );
  }

  addContactsToPhone() async {
    try {
      await contactProvider.addContacts(selectedContacts);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.leftSlide,
        title: 'Contacts added successfully!',
        btnOkOnPress: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LandingPage(),
              ),
              ModalRoute.withName("/"));
        },
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Dialog Title',
        desc: '$e',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
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
            onPressed: () => showImportActionDialog(),
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
}
