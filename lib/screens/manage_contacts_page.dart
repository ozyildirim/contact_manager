import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:contact_manager/core/providers/contact_provider.dart';
import 'package:contact_manager/core/services/contact_service.dart';
import 'package:contact_manager/widgets/bottom_sheet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ManageContactsPage extends StatefulWidget {
  const ManageContactsPage({super.key});

  @override
  State<ManageContactsPage> createState() => _ManageContactsPageState();
}

class _ManageContactsPageState extends State<ManageContactsPage> {
  late ContactProvider contactProvider;
  bool isSelectionMode = false;
  Logger logger = Logger();

  List<Contact> selectedContacts = [];
  List<Contact> searchedContacs = [];
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    fetchContacts();
    super.initState();
  }

  fetchContacts() {
    contactProvider.fetchContacts();
  }

  get isSelectedAll {
    return selectedContacts.length == contactProvider.contacts!.length;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    contactProvider = Provider.of<ContactProvider>(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: leadingActionButton,
        leadingWidth: 64,
        title: Text(selectedContacts.isNotEmpty
            ? "${selectedContacts.length} Contact Selected"
            : "Manage Contacts"),
        actions: [actionButton],
      ),
      body: Container(
        child: contactProvider.state == ViewState.Busy ||
                contactProvider.contacts == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      focusNode: searchFocusNode,
                      // onEditingComplete: (value) {},
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            searchedContacs.clear();
                            selectedContacts.clear();
                          });
                          return;
                        } else {
                          List<Contact> list = [];
                          for (Contact element in contactProvider.contacts!) {
                            if (element.displayName
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              list.add(element);
                            }
                          }
                          setState(() {
                            searchedContacs = list;
                          });
                        }

                        print(value);
                        print(searchedContacs);
                      },
                      decoration: const InputDecoration(
                        hintText: "Search Contact",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchedContacs.isNotEmpty
                          ? searchedContacs.length + 1
                          : contactProvider.contacts!.length + 1,
                      itemBuilder: ((context, index) {
                        if (index == 0) {
                          if (isSelectionMode) {
                            return ListTile(
                              title: Text(
                                isSelectedAll ? "Unselect All" : "Select All",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: isSelectedAll
                                  ? unselectAllContacts
                                  : selectAllContacts,
                            );
                          }
                          return Container();
                        } else {
                          var item = searchedContacs.isNotEmpty
                              ? searchedContacs[index - 1]
                              : contactProvider.contacts![index - 1];
                          return ListTile(
                            trailing: contactProvider.getContactPicture(item),
                            title: Text(item.displayName),
                            subtitle:
                                contactProvider.getContactItemSubtitle(item),
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
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  selectAllContacts() {
    for (var element in contactProvider.contacts!) {
      if (selectedContacts
          .any((selectedElement) => selectedElement.id == element.id)) {
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
            onPressed: () => showActions(), child: const Text("Actions"));
      }
      return Container();
    } else {
      return TextButton(onPressed: changeMode, child: const Text("Select"));
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

  showActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomModalSheetWidget(
        sheetTitle: "Actions",
        sheetItems: [
          ModalSheetItem(
            title: "Delete Selected Contacts",
            icon: Icons.delete,
            onTap: () => deleteContacts(selectedContacts),
          ),
          ModalSheetItem(
            title: "Export Selected Contacts",
            icon: Icons.data_exploration,
            onTap: () => exportContacts(selectedContacts),
          ),
        ],
      ),
    );
  }

  exportContacts(List<Contact> contacts) {
    logger.i(contacts.toString());
    ContactService.createVcfFile(contacts);
  }

  deleteContacts(List<Contact> contacts) async {
    Navigator.pop(context);
    try {
      await contactProvider.deleteContacts(contacts);
      setState(() {
        isSelectionMode = false;
        selectedContacts.clear();
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.leftSlide,
        title: 'Contacts deleted successfully!',
        btnOkOnPress: () {
          // Navigator.pop(context);
        },
      ).show();
    } catch (e) {}
  }
}
