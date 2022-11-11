import 'package:contact_manager/screens/import_contacts_page.dart';
import 'package:contact_manager/screens/manage_contacts_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  var pages = [
    const ManageContactsPage(),
    const ImportContactsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme:
            IconThemeData(color: Theme.of(context).primaryColor),
        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Import',
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: pages[_currentIndex],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
