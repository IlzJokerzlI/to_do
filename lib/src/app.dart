import "package:flutter/material.dart";
import 'package:learn/src/pages/home_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: HomePage(),
    );
  }
}
