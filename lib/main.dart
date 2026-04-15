import 'package:car_api_final_app/services/dotenv_service.dart';
import 'package:car_api_final_app/widgets/main_page_scaffold.dart';
import 'package:car_api_final_app/pages/combustible_list_page.dart';
import 'package:car_api_final_app/pages/combustible_registro_page.dart';
import 'package:car_api_final_app/pages/foro_crear_tema_page.dart';
import 'package:car_api_final_app/pages/foro_lista_page.dart';
import 'package:car_api_final_app/pages/foro_detalle_page.dart';
import 'package:car_api_final_app/pages/foro_mis_temas_page.dart';
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
    DotenvService.SaveAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData(),
      darkTheme: darkThemeData(),

      initialRoute: '/',
      routes: {
        '/': (context) => MainScaffold(),
        '/combustible': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return CombustibleListPage(vehiculoId: vehiculoId);
        },
        '/combustible/registro': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return CombustibleRegistroPage(vehiculoId: vehiculoId);
        },

          '/foro/crear': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return ForoCrearTemaPage(vehiculoId: vehiculoId);
        },

        '/foro': (context) => const ForoListaPage(),
        '/foro/detalle': (context) {
          final temaId = ModalRoute.of(context)!.settings.arguments as int;
          return ForoDetallePage(temaId: temaId);
        },
        '/foro/mis-temas': (context) => const ForoMisTemasPage(),
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
