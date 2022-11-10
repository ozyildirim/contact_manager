import 'package:flutter/material.dart';

class CustomModalSheetWidget extends StatelessWidget {
  String sheetTitle;
  List<ModalSheetItem> sheetItems;
  CustomModalSheetWidget(
      {required this.sheetTitle, required this.sheetItems, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (context) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  title: Text(
                    sheetTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  onTap: null,
                ),
                const Divider(),
                for (ModalSheetItem item in sheetItems)
                  ModalSheetListTile(item: item),
                ListTile(
                  title: const Text('Cancel',
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
}

class ModalSheetListTile extends StatelessWidget {
  final ModalSheetItem item;
  const ModalSheetListTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink,
          child: Icon(
            item.icon,
            color: Colors.white,
          ),
        ),
        title: Text(item.title),
        subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
        onTap: item.onTap);
  }
}

class ModalSheetItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  ModalSheetItem({required this.title, this.subtitle, this.icon, this.onTap});
}
