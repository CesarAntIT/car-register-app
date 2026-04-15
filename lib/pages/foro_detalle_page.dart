import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';

class ForoDetallePage extends StatefulWidget {
  final int temaId;
  const ForoDetallePage({super.key, required this.temaId});

  @override
  State<ForoDetallePage> createState() => _ForoDetallePageState();
}

class _ForoDetallePageState extends State<ForoDetallePage> {
  Map<String, dynamic>? _tema;
  bool _loading = true;
  final _respuestaController = TextEditingController();
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    try {
      final data = await HttpService.getDetalleTema(widget.temaId)
          .timeout(const Duration(seconds: 10));
      setState(() {
        _tema = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _responder() async {
    if (_respuestaController.text.trim().isEmpty) return;
    setState(() => _enviando = true);

    final ok = await HttpService.responderTema(
      temaId: widget.temaId,
      contenido: _respuestaController.text.trim(),
    );

    setState(() => _enviando = false);

    if (ok) {
      _respuestaController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Respuesta publicada"),
          backgroundColor: Colors.green,
        ),
      );
      _cargar();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al publicar respuesta"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _respuestaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del Tema")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tema == null
              ? const Center(child: Text("No se encontró el tema."))
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Encabezado del tema
                          Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_tema!['vehiculoFoto'] != null)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      _tema!['vehiculoFoto'],
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const SizedBox(),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _tema!['titulo'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _tema!['descripcion'] ?? '',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.person,
                                              size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            _tema!['autor'] ?? '',
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.directions_car,
                                              size: 14,
                                              color: Colors.deepOrange),
                                          const SizedBox(width: 4),
                                          Text(
                                            _tema!['vehiculo'] ?? '',
                                            style: const TextStyle(
                                                color: Colors.deepOrange),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Respuestas",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...(_tema!['respuestas'] as List<dynamic>? ?? [])
                              .map((r) => Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                    // Caja de respuesta
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _respuestaController,
                              decoration: const InputDecoration(
                                hintText: "Escribe tu respuesta...",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _enviando
                              ? const CircularProgressIndicator()
                              : IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.deepOrange,
                                  ),
                                  onPressed: _responder,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}