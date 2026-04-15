import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';

class ForoListaPage extends StatefulWidget {
  const ForoListaPage({super.key});

  @override
  State<ForoListaPage> createState() => _ForoListaPageState();
}

class _ForoListaPageState extends State<ForoListaPage> {
  List<dynamic> _temas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    try {
      final data = await HttpService.getListaTemasForo()
          .timeout(const Duration(seconds: 10));
      setState(() {
        _temas = data['data'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foro Comunitario"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks),
            onPressed: () => Navigator.pushNamed(context, '/foro/mis-temas'),
            tooltip: "Mis temas",
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _temas.isEmpty
              ? const Center(child: Text("No hay temas aún."))
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _temas.length,
                    itemBuilder: (context, index) {
                      final t = _temas[index];
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
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            '/foro/crear',
            arguments: 24, // vehiculoId — cuando haya login, pasar el real
          );
          _cargar();
        },
        icon: const Icon(Icons.add),
        label: const Text("Nuevo Tema"),
      ),
    );
  }
}