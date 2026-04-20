import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.onCardPressed});
  final Function(int) onCardPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Lista de imágenes y frases motivacionales
    final List<Map<String, String>> carShowcase = [
      {
        'url':
            'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=1000',
        'quote': 'Tu auto es el reflejo de tu disciplina.',
      },
      {
        'url':
            'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=1000',
        'quote': 'El mantenimiento preventivo es amor por la ingeniería.',
      },
      {
        'url':
            'https://images.stockcake.com/public/1/e/5/1e52a6bb-302f-491d-9ce7-631521fd9e17_large/city-night-drive-stockcake.jpg',
        'quote': 'No solo conduces, cuidas una obra de arte.',
      },
      {
        'url':
            'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=1000',
        'quote': 'La potencia sin control no es nada; el cuidado es la clave.',
      },
      {
        'url':
            'https://www.jalopnik.com/jalopnik/images/befea684715ad58d0cdee768b0baae05.jpg',
        'quote': 'Un motor bien cuidado suena mejor que cualquier canción.',
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            // --- SLIDER DE IMÁGENES ---
            CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.85,
              ),
              items: carShowcase.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return LandingCarItem(item: item);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),
            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                AccessCard(
                  title: 'Mi Perfil',
                  icon: Icons.build_circle_outlined,
                  color: Colors.deepOrange,
                ),
                AccessCard(
                  title: 'Mis Vehiculos',
                  icon: Icons.directions_car_filled_outlined,
                  color: isDark ? Colors.deepOrange : Colors.deepOrange,
                  targetIndex: 2,
                  changePage: onCardPressed,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: AccessCard(
                title: 'Modulos Publicos',
                icon: Icons.no_accounts,
                color: isDark ? Colors.deepOrange : Colors.deepOrange,
                targetIndex: 1,
                changePage: onCardPressed,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: AccessCard(
                title: 'Acerca De',
                icon: Icons.info_outline,
                color: isDark ? Colors.deepOrange : Colors.deepOrange,
                targetIndex: 3,
                changePage: onCardPressed,
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class LandingCarItem extends StatelessWidget {
  const LandingCarItem({super.key, required this.item});
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(item['url']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            item['quote']!,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}

class AccessCard extends StatelessWidget {
  const AccessCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.changePage,
    this.targetIndex,
  });

  final String title;
  final IconData icon;
  final Color color;
  final Function(int)? changePage;
  final int? targetIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => changePage?.call(targetIndex!),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 5, width: 3000),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
