import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyFaster());
}

class MyFaster extends StatelessWidget {
  Color _primaryColor = HexColor('#FF8700');
  Color _accentColor = HexColor('#FF8700');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Faster',
      theme: ThemeData(
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      home: Splashcreen(title: 'My Faster'),
    );
  }
}
