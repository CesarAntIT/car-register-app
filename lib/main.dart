import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text.rich(
            TextSpan(
              text: "AUTOZONE",
              style: TextStyle(fontSize: 20),
              children: [
                TextSpan(
                  text: "Itla Vehicle Management",
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
        body: Placeholder(),
      ),
    );
  }
}
