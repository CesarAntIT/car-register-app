import 'package:car_api_final_app/pages/profile_page.dart';
import 'package:car_api_final_app/pages/resumen_page.dart';
import 'package:car_api_final_app/widgets/navi_drawer.dart';
import 'package:flutter/material.dart';
import 'package:car_api_final_app/services/dotenv_service.dart';
import 'package:car_api_final_app/pages/combustible_list_page.dart';
import 'package:car_api_final_app/pages/combustible_registro_page.dart';
import 'package:car_api_final_app/pages/finanzas_page.dart';
import 'package:car_api_final_app/pages/foro_crear_tema_page.dart';
import 'package:car_api_final_app/pages/foro_lista_page.dart';
import 'package:car_api_final_app/pages/foro_detalle_page.dart';
import 'package:car_api_final_app/pages/foro_mis_temas_page.dart';
import 'package:car_api_final_app/pages/gasto_registro_page.dart';
import 'package:car_api_final_app/pages/goma_pinchazo_registro_page.dart';
import 'package:car_api_final_app/pages/gomas_page.dart';
import 'package:car_api_final_app/pages/ingreso_registro_page.dart';
import 'package:car_api_final_app/pages/mantenimientos_page.dart';
import 'package:car_api_final_app/pages/mantenimiento_crear_page.dart';
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
    // DotenvService.SaveAuth();
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
        '/gomas': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return GomasPage(vehiculoId: vehiculoId);
        },
        '/gomas/pinchazo': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return GomaPinchazoRegistroPage(
            vehiculoId: args['vehiculoId'] as int,
            gomaId: args['gomaId'] as int,
            posicion: (args['posicion'] ?? 'Sin posicion').toString(),
          );
        },
        '/finanzas': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return FinanzasPage(vehiculoId: vehiculoId);
        },
        '/finanzas/gasto': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return GastoRegistroPage(vehiculoId: vehiculoId);
        },
        '/finanzas/ingreso': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return IngresoRegistroPage(vehiculoId: vehiculoId);
        },

        '/mantenimiento': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return MantenimientoPage(vehiculoId: vehiculoId);
        },
        '/mantenimiento/crear': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return MantenimientoCrearPage(vehiculoId: vehiculoId);
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
        '/perfil': (context) => ProfilePage(),
        '/vehiculos/resumen': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as int;
          return ResumenPage(vehiculoId: vehiculoId);
        },
      },
    );
  }

  // --- TU ESTILO LIGHT ---
  ThemeData lightThemeData() {
    return ThemeData(
      useMaterial3: true,
      splashColor: Colors.deepOrange[200],
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(backgroundColor: Colors.deepOrange),
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
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white, // Color of the text and icons
          textStyle: GoogleFonts.interTight(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.deepOrange,
          textStyle: GoogleFonts.interTight(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // --- TU ESTILO DARK ---
  ThemeData darkThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.deepOrange,
        ),
      ),
      textTheme: TextTheme(
        titleMedium: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: GoogleFonts.interTight(color: Colors.white, fontSize: 14),
        bodySmall: GoogleFonts.interTight(color: Colors.white),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: Colors.black,
        indicatorColor: Colors.deepOrange,
        indicatorShape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.deepOrange),
        ),
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
      cardTheme: const CardThemeData(
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.deepOrange, // Orange text on black background
          side: const BorderSide(
            color: Colors.deepOrange,
          ), // Optional border for dark mode
          textStyle: GoogleFonts.interTight(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.interTight(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}