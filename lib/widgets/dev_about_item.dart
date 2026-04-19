import 'package:car_api_final_app/models/about_dev_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DevAboutItem extends StatelessWidget {
  const DevAboutItem({super.key, required this.dev});

  final AboutDev dev;

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Essential for use inside ListViews
          children: [
            // Developer Image / Placeholder
            const SizedBox(
              height: 100,
              width: 100,
              child:
                  Placeholder(), // Replace with Image.file or CircleAvatar later
            ),
            const SizedBox(height: 10),

            // Name and Lastname
            Text(
              "${dev.name} ${dev.lastname}",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

            // ID / Matricula
            Text(
              "Matrícula: ${dev.matricula}",
              style: Theme.of(context).textTheme.labelMedium,
            ),

            const Divider(height: 20),

            // Contact Info Labels
            Text(
              "Tel: ${dev.phone}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              "Email: ${dev.email}",
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 10),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Call Button
                IconButton(
                  onPressed: () => _launchUrl('tel:${dev.phone}'),
                  icon: const Icon(Icons.phone),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),

                // Telegram Button
                IconButton(
                  onPressed: () => _launchUrl('https://t.me/${dev.phone}'),
                  icon: const Icon(Icons.telegram),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.lightBlue[400],
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),

                // Email Button
                IconButton(
                  onPressed: () => _launchUrl(
                    'mailto:${dev.email}?subject=Contact from AutoZone (Practica final)',
                  ),
                  icon: const Icon(Icons.email),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
