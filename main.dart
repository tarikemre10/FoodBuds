import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "package:foodbuds0_1/firebase_options.dart";
import "package:get/get.dart";
import "ui/authentication_screen/authentication_screen.dart";
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FoodbuD',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}
