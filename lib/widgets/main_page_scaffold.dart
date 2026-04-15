import 'package:car_api_final_app/pages/news_list_page.dart';
import 'package:car_api_final_app/pages/catalogo_vehiculos_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  var _currentPage = 0;
  final _pageController = PageController();

  void _changePage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      body: PageView(
        controller: _pageController,
        onPageChanged: _changePage,
        children: [
          Container(color: Colors.red),
          Container(color: Colors.yellow),
          const CatalogoVehiculosScreen(),
          const NewsListPage(),
          Container(color: Colors.pink),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn,
          );
        },
        items: const [
          BottomNavigationBarItem(label: "Inicio", icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: "Videos",
            icon: Icon(Icons.play_arrow),
          ),
          BottomNavigationBarItem(
            label: "Catalogo",
            icon: Icon(Icons.car_rental),
          ),
          BottomNavigationBarItem(label: "News", icon: Icon(Icons.newspaper)),
          BottomNavigationBarItem(label: "Foro", icon: Icon(Icons.book)),
        ],
      ),
    );
  }
}
