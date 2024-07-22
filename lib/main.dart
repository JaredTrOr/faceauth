import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/auth_home_page.dart';
import 'package:flutter/material.dart';

void main() {
  setupServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthHomePage(),
    );
  }
}
