import 'package:flutter/material.dart';

class MyTemasItem extends StatelessWidget {
  const MyTemasItem({super.key, required this.t});

  final dynamic t;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.forum, color: Colors.white),
        ),
        title: Text.rich(
          TextSpan(
            text: t['titulo'] ?? '',
            children: [
              TextSpan(
                text: "\n${t['vehiculo']}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          t['fecha'] ?? '',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.comment, size: 16),
            Text(
              '${t['totalRespuestas'] ?? 0}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap: () =>
            Navigator.pushNamed(context, '/foro/detalle', arguments: t['id']),
      ),
    );
  }
}
