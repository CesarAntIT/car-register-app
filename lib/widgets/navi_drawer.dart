import 'package:car_api_final_app/pages/catalogo_vehiculos_screen.dart';
import 'package:car_api_final_app/widgets/main_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainAppNavigation extends StatefulWidget {
  const MainAppNavigation({super.key});

  @override
  State<MainAppNavigation> createState() => _MainAppNavigationState();
}

class _MainAppNavigationState extends State<MainAppNavigation> {
  var _pageIndex = 0;

  void _changePage(int index) async {
    if (mounted) {
      setState(() {
        _pageIndex = index;
      });
      await Future.delayed(Duration(milliseconds: 5));
      Navigator.pop(context);
    }
    null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: "AUTOZONE",
            style: GoogleFonts.sairaStencilOne(
              fontSize: 30,
              fontStyle: FontStyle.italic,
            ),
            children: const [
              TextSpan(
                text: "\nItla Vehicle Management\n",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: _pageIndex,
        onDestinationSelected: (index) => _changePage(index),
        header: Text.rich(
          TextSpan(
            text: "AUTOZONE",
            style: GoogleFonts.sairaStencilOne(
              fontSize: 30,
              fontStyle: FontStyle.italic,
            ),
            children: const [
              TextSpan(
                text: "\nItla Vehicle Management\n",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          style: TextStyle(color: Colors.deepOrange),
        ),
        children: [
          NavigationDrawerDestination(
            icon: Icon(Icons.home),
            label: Text("Inicio"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.car_repair),
            label: Text("Mis Vehiculos"),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.info_outline),
            label: Text("Acerca De"),
          ),
        ],
      ),

      body: [
        MainScaffold(),
        CatalogoVehiculosScreen(),
        Placeholder(),
      ][_pageIndex],
    );
  }
}
