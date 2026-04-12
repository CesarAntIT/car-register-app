import 'package:car_api_final_app/services/dotenv_service.dart';
import 'package:car_api_final_app/widgets/main_page_scaffold.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData(),
      darkTheme: darkThemeData(),

      initialRoute: '/',
      routes: {
        //TODO: Add the Login, My Vehicles and Profile Pages to Router
        '/': (context) => MainScaffold(),
      },
    );
  }

  //TODO: Determine a defenitive ColorScheme
  ThemeData lightThemeData() {
    return ThemeData(
      splashColor: Colors.deepOrange[200],
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 20,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepOrange,

        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
      ),
    );
  }

  ThemeData darkThemeData() {
    return ThemeData(
      splashColor: Colors.deepOrange[200],
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.deepOrange,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 20,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,

        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
