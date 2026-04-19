import 'package:car_api_final_app/widgets/navi_drawer.dart';
import 'package:flutter/material.dart';
import 'package:car_api_final_app/services/dotenv_service.dart';
import 'package:car_api_final_app/widgets/main_page_scaffold.dart';
import 'package:car_api_final_app/pages/combustible_list_page.dart';
import 'package:car_api_final_app/pages/combustible_registro_page.dart';
import 'package:car_api_final_app/pages/foro_crear_tema_page.dart';
import 'package:car_api_final_app/pages/foro_lista_page.dart';
import 'package:car_api_final_app/pages/foro_detalle_page.dart';
import 'package:car_api_final_app/pages/foro_mis_temas_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/catalogo_vehiculos_screen.dart';

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
      title: 'Autozone ITLA',
      theme: lightThemeData(),
      darkTheme: darkThemeData(),

      initialRoute: '/',
      routes: {
        '/': (context) => MainAppNavigation(),
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
        '/vehiculos': (context) => const CatalogoVehiculosScreen(),
      },
    );
  }

  // TODO: Determine a definitive ColorScheme
  ThemeData lightThemeData() {
    return ThemeData(
      splashColor: Colors.deepOrange[200],
      iconButtonTheme: IconButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
      ),
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.sairaStencilOne(fontSize: 26),
      ),
      textTheme: TextTheme(labelMedium: GoogleFonts.interTight(fontSize: 14)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 20,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepOrange,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Colors.deepOrange,
        indicatorShape: Border.all(style: BorderStyle.none),
        tileHeight: 75,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : Colors.black,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return GoogleFonts.inter(
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : Colors.black,
          );
        }),
      ),
    );
  }

  ThemeData darkThemeData() {
    return ThemeData(
      iconButtonTheme: IconButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.deepOrange,
        ),
      ),
      textTheme: TextTheme(
        titleMedium: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight(500),
        ),
        labelMedium: GoogleFonts.interTight(color: Colors.white, fontSize: 14),

        bodySmall: GoogleFonts.interTight(color: Colors.white),
      ),

      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: Colors.black,
        indicatorColor: Colors.deepOrange,
        indicatorShape: Border.all(style: BorderStyle.solid),
        tileHeight: 75,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? Colors.black
                : Colors.white,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return GoogleFonts.inter(
            color: states.contains(WidgetState.selected)
                ? Colors.black
                : Colors.white,
          );
        }),
      ),

      cardTheme: CardThemeData(
        color: Colors.black,
        shadowColor: Colors.deepOrangeAccent,
        elevation: 4,
      ),
      splashColor: Colors.deepOrange[200],
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.deepOrange,
        titleTextStyle: GoogleFonts.sairaStencilOne(fontSize: 26),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 20,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
