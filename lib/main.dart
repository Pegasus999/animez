import 'package:flutter/material.dart';
import 'package:zanime/Screens/SomethingWrong.dart';
import 'package:zanime/Screens/Splash.dart';
import 'package:zanime/Services/API.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  _homePage() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Zone',
      home: Scaffold(body: SafeArea(child: SplashScreen())),
    );
  }

  _somethingWrong() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Zone',
      home: SomethingWrongScreen(),
    );
  }

  _loadingPage() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Zone',
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API.isActive(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return _loadingPage();
        bool active = snapshot.data ?? true;
        return active ? _homePage() : _somethingWrong();
      },
    );
  }
}
