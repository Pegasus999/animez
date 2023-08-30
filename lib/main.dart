import 'package:flutter/material.dart';
import 'package:zanime/Screens/Splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Zone',
      home: Scaffold(body: SafeArea(child: SplashScreen())),
    );
  }
}
