import 'package:flutter/material.dart';

class ForoCommentItem extends StatelessWidget {
  const ForoCommentItem({super.key, required this.r});
  final dynamic r;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              r['autor'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 4),
            Text(r['contenido'] ?? ''),
            const SizedBox(height: 4),
            Text(
              r['fecha'] ?? '',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
