import 'dart:async';

import 'package:flutter/material.dart';

import 'package:zanime/Screens/HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => _redirectLogin());
  }

  _redirectLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromRGBO(98, 45, 145, 1),
            Color.fromRGBO(28, 16, 172, 0.94)
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/Logo.png',
            ),
          ),
        ],
      ),
    );
  }
}
