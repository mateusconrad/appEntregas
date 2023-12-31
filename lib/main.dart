import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Views/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    theme: ThemeData(
      brightness: Brightness.dark,
    ),
  ));
}