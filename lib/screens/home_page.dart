import 'package:contact_manager/screens/import_contacts_page.dart';
import 'package:contact_manager/widgets/home_menu_button.dart';
import 'package:contact_manager/screens/manage_contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.4,
                child: const Center(
                  child: Text(
                    "Contact Manager\nPro",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    // childAspectRatio: 1.5,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 40,
                    crossAxisCount: 2,
                    children: [
                      HomeMenuButton(
                          title: "Backup", callback: () {}, icon: Icons.backup),
                      HomeMenuButton(
                          title: "Manage",
                          callback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ManageContactsPage(),
                              ),
                            );
                          },
                          icon: Icons.backup),
                      HomeMenuButton(
                          title: "Sync", callback: () {}, icon: Icons.backup),
                      HomeMenuButton(
                          title: "Import",
                          callback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ImportContactsPage(),
                              ),
                            );
                          },
                          icon: Icons.backup),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
