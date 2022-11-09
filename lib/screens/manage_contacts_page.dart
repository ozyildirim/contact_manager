import 'package:contact_manager/core/providers/contact_provider.dart';
import 'package:contact_manager/core/services/contact_service.dart';
import 'package:contact_manager/widgets/contact_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';

class ManageContactsPage extends StatefulWidget {
  const ManageContactsPage({super.key});

  @override
  State<ManageContactsPage> createState() => _ManageContactsPageState();
}

class _ManageContactsPageState extends State<ManageContactsPage> {
  late ContactProvider contactProvider;
  bool isSelectionMode = false;

  List<Contact> selectedContacts = [];

  @override
  void initState() {
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    fetchContacts();
    super.initState();
  }

  fetchContacts() {
    contactProvider.fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
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
            : ListView.builder(
                itemCount: contactProvider.contacts!.length + 1,
                itemBuilder: ((context, index) {
                  if (index == 0) {
                    if (isSelectionMode) {
                      return ListTile(
                        title: const Text(
                          "Select All",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: selectAllTap,
                      );
                    }
                    return Container();
                  } else {
                    var item = contactProvider.contacts![index - 1];
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
              ),
      ),
    );
  }

  selectAllTap() {
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

  showActions() {
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
                      'Actions',
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
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text('Delete Selected Contacts'),
                    onTap: () async {}),
                const Divider(),
                ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.data_exploration,
                        color: Colors.white,
                      ),
                    ),
                    /*  */
                    title: const Text('Export Selected Contacts'),
                    onTap: () => exportContacts(selectedContacts)),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.map,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Haritadan Seç'),
                  onTap: () async {},
                ),
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

  exportContacts(List<Contact> contacts) {
    ContactService.createVcfFile(contacts);
  }
}
