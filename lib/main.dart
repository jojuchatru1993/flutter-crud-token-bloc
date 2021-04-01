import 'package:flutter/material.dart';

import 'package:form/src/blocs/provider.dart';

import 'package:form/src/pages/home_page.dart';
import 'package:form/src/pages/login_page.dart';
import 'package:form/src/pages/product_page.dart';
import 'package:form/src/pages/register_page.dart';
import 'package:form/src/shared_preferences/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();

  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new UserPreferences();

    print(prefs.token);

    return Provider(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            initialRoute: 'login',
            routes: {
              'register': (BuildContext context) => RegisterPage(),
              'login': (BuildContext context) => LoginPage(),
              'home': (BuildContext context) => HomePage(),
              'product': (BuildContext context) => ProductPage(),
            },
            theme: ThemeData(primaryColor: Colors.deepPurple)));
  }
}
