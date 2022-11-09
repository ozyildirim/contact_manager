import 'package:contact_manager/core/constants/theme_constants.dart';
import 'package:contact_manager/core/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/helpers/locator.dart';
import 'screens/home_page.dart';

void main() {
  setupLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ContactProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contact Manager Pro',
        theme: themeData,
        home: const HomePage(),
      ),
    );
  }
}
