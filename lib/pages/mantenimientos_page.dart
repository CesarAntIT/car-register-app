import 'package:car_api_final_app/models/mantenimiento_model.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';

class MantenimientoPage extends StatefulWidget {
  final int vehiculoId;
  const MantenimientoPage({super.key, required this.vehiculoId});

  @override
  State<MantenimientoPage> createState() => _MantenimientoPageState();
}

class _MantenimientoPageState extends State<MantenimientoPage> {
  List<Mantenimiento> _registros = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    try {
      final data = await HttpService.getListaMantenimientos(
        widget.vehiculoId,
      ).timeout(const Duration(seconds: 10));
      setState(() {
        _registros = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _eliminar(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar mantenimiento'),
        content: const Text('¿Deseas eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final ok = await HttpService.eliminarMantenimiento(id);
      if (ok) {
        _cargar();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mantenimiento eliminado')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al eliminar'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  IconData _iconoTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'preventivo':
        return Icons.shield_outlined;
      case 'correctivo':
        return Icons.build_outlined;
      case 'predictivo':
        return Icons.analytics_outlined;
      default:
        return Icons.settings_outlined;
    }
  }

  Color _colorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'preventivo':
        return Colors.green;
      case 'correctivo':
        return Colors.deepOrange;
      case 'predictivo':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mantenimientos')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _registros.isEmpty
          ? const Center(child: Text('No hay mantenimientos registrados.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _registros.length,
              itemBuilder: (context, index) {
                final m = _registros[index];
                final color = _colorTipo(m.tipo);
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color,
                      child: Icon(_iconoTipo(m.tipo), color: Colors.white),
                    ),
                    title: Text(
                      m.tipo.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${m.piezas}  •  ${m.fecha}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'RD\$ ${m.costo.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _eliminar(m.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            '/mantenimiento/crear',
            arguments: widget.vehiculoId,
          );
          _cargar();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
