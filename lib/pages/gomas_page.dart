import 'package:car_api_final_app/models/goma_model.dart';
import 'package:car_api_final_app/models/pinchazo_model.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';

class GomasPage extends StatefulWidget {
  final int vehiculoId;

  const GomasPage({super.key, required this.vehiculoId});

  @override
  State<GomasPage> createState() => _GomasPageState();
}

class _GomasPageState extends State<GomasPage> {
  final List<String> _estados = const [
    'buena',
    'regular',
    'mala',
    'reemplazada',
  ];

  List<Goma> _gomas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    try {
      final data = await HttpService.getListaGomas(
        widget.vehiculoId,
      ).timeout(const Duration(seconds: 10));
      setState(() {
        _gomas = data;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _seleccionarEstado(Goma goma) async {
    final nuevoEstado = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Actualizar estado de ${goma.posicion}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ..._estados.map(
                (estado) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    _iconoEstado(estado),
                    color: _colorEstado(estado),
                  ),
                  title: Text(_capitalizar(estado)),
                  trailing: goma.estado.toLowerCase() == estado
                      ? const Icon(Icons.check, color: Colors.deepOrange)
                      : null,
                  onTap: () => Navigator.pop(ctx, estado),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (nuevoEstado == null || nuevoEstado == goma.estado.toLowerCase()) return;

    final ok = await HttpService.actualizarEstadoGoma(
      gomaId: goma.id,
      estado: nuevoEstado,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Estado actualizado correctamente' : 'No se pudo actualizar',
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) _cargar();
  }

  Future<void> _registrarPinchazo(Goma goma) async {
    await Navigator.pushNamed(
      context,
      '/gomas/pinchazo',
      arguments: {
        'vehiculoId': widget.vehiculoId,
        'gomaId': goma.id,
        'posicion': goma.posicion,
      },
    );
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estado de Gomas')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _gomas.isEmpty
          ? RefreshIndicator(
              onRefresh: _cargar,
              child: ListView(
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text('No hay gomas registradas para este vehiculo.')),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _cargar,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _gomas.length,
                itemBuilder: (context, index) {
                  final goma = _gomas[index];
                  final ultimoPinchazo =
                      goma.pinchazos.isNotEmpty ? goma.pinchazos.first : null;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: _colorEstado(goma.estado),
                                child: Icon(
                                  _iconoEstado(goma.estado),
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goma.posicion,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text('Eje: ${goma.eje}'),
                                  ],
                                ),
                              ),
                              _estadoChip(goma.estado),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 18,
                                color: Colors.deepOrange,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Pinchazos registrados: ${goma.totalPinchazos}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          if (ultimoPinchazo != null) ...[
                            const SizedBox(height: 10),
                            _pinchazoInfo(ultimoPinchazo),
                          ],
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _seleccionarEstado(goma),
                                icon: const Icon(Icons.sync_alt),
                                label: const Text('Cambiar estado'),
                              ),
                              FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                ),
                                onPressed: () => _registrarPinchazo(goma),
                                icon: const Icon(Icons.add_alert),
                                label: const Text('Registrar pinchazo'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _pinchazoInfo(Pinchazo pinchazo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ultimo pinchazo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(pinchazo.descripcion),
          if (pinchazo.fecha.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              pinchazo.fecha,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }

  Widget _estadoChip(String estado) {
    final color = _colorEstado(estado);
    return Chip(
      backgroundColor: color.withOpacity(0.12),
      side: BorderSide(color: color.withOpacity(0.2)),
      avatar: Icon(_iconoEstado(estado), size: 18, color: color),
      label: Text(
        _capitalizar(estado),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _colorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'buena':
        return Colors.green;
      case 'regular':
        return Colors.amber.shade800;
      case 'mala':
        return Colors.red;
      case 'reemplazada':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _iconoEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'buena':
        return Icons.check_circle;
      case 'regular':
        return Icons.tire_repair;
      case 'mala':
        return Icons.report_problem;
      case 'reemplazada':
        return Icons.autorenew;
      default:
        return Icons.circle;
    }
  }

  String _capitalizar(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
