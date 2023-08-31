import 'package:flutter/material.dart';

class Constant {
  static Color main = Color.fromRGBO(98, 45, 145, 1);
  static Color background = Color.fromRGBO(20, 20, 20, 1);
  static Color white = Colors.white;

  static buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
