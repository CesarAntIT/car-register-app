import 'package:flutter/material.dart';

class ForoListItem extends StatelessWidget {
  const ForoListItem({
    super.key,
    required this.t,
  });

  final dynamic t;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(t['vehiculoFoto'] ?? ''),
          onBackgroundImageError: (_, __) {},
          child: const Icon(Icons.directions_car),
        ),
        title: Text(
          t['titulo'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t['autor'] ?? ''),
            Text(
              t['vehiculo'] ?? '',
              style: const TextStyle(color: Colors.deepOrange),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.comment, size: 16),
            Text('${t['totalRespuestas'] ?? 0}'),
          ],
        ),
        onTap: () => Navigator.pushNamed(
          context,
          '/foro/detalle',
          arguments: t['id'],
        ),
      ),
    );
  }
}