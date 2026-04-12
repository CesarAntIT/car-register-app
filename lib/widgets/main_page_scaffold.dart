import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  //Valor de la Página Actual del Scaffold
  var _currentPage = 0;

  void _changePage(int index) {
    setState(() {
      _currentPage = index;
    });
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
            children: [
              TextSpan(
                text: "\nItla Vehicle Management",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
      body: Placeholder(),

      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        currentIndex: _currentPage,
        onTap: _changePage,
        items: [
          BottomNavigationBarItem(label: "Inicio", icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: "Videos",
            icon: Icon(Icons.play_arrow),
          ),
          BottomNavigationBarItem(
            label: "Catalogo",
            icon: Icon(Icons.car_rental),
          ),
          BottomNavigationBarItem(label: "Foro", icon: Icon(Icons.book)),
        ],
      ),
    );
  }
}
