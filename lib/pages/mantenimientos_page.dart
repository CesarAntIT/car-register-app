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
  String? _filtroTipo;

  final List<String> _tipos = [
    'Todos',
    'Preventivo',
    'Correctivo',
    'Predictivo',
    'Otro',
  ];

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
        tipo: _filtroTipo,
      ).timeout(const Duration(seconds: 10));
      setState(() {
        _registros = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _verDetalle(Mantenimiento m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: controller,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Tipo badge
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _colorTipo(m.tipo),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    m.tipo.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _detalleItem(Icons.description_outlined, 'Piezas', m.piezas),
              _detalleItem(
                Icons.attach_money,
                'Costo',
                'RD\$ ${m.costo.toStringAsFixed(2)}',
              ),
              _detalleItem(Icons.calendar_today, 'Fecha', m.fecha),
              const SizedBox(height: 16),
              // Fotos
              if (m.fotos.isNotEmpty) ...[
                const Text(
                  'Fotos',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: m.fotos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _verFotoCompleta(m.fotos[index]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          m.fotos[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ] else
                const Center(
                  child: Text(
                    'Sin fotos',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _verFotoCompleta(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: Center(child: InteractiveViewer(child: Image.network(url))),
        ),
      ),
    );
  }

  Widget _detalleItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepOrange, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
      body: Column(
        children: [
          // FILTRO POR TIPO
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tipos.map((t) {
                  final seleccionado =
                      (t == 'Todos' && _filtroTipo == null) || t == _filtroTipo;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(t),
                      selected: seleccionado,
                      selectedColor: Colors.deepOrange,
                      labelStyle: TextStyle(
                        color: seleccionado ? Colors.white : null,
                        fontWeight: seleccionado
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _filtroTipo = t == 'Todos' ? null : t;
                        });
                        _cargar();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // LISTA
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _registros.isEmpty
                ? const Center(
                    child: Text('No hay mantenimientos registrados.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _registros.length,
                    itemBuilder: (context, index) {
                      final m = _registros[index];
                      final color = _colorTipo(m.tipo);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () => _verDetalle(m),
                          leading: CircleAvatar(
                            backgroundColor: color,
                            child: Icon(
                              _iconoTipo(m.tipo),
                              color: Colors.white,
                            ),
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'RD\$ ${m.costo.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  if (m.fotos.isNotEmpty)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.photo,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          ' ${m.fotos.length}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
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
        ],
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
