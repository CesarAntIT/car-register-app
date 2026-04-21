import 'package:car_api_final_app/models/combustible_model.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:car_api_final_app/utils/format_utils.dart';
import 'package:flutter/material.dart';

class CombustibleListPage extends StatefulWidget {
  final int vehiculoId;
  const CombustibleListPage({super.key, required this.vehiculoId});

  @override
  State<CombustibleListPage> createState() => _CombustibleListPageState();
}

class _CombustibleListPageState extends State<CombustibleListPage> {
  List<Combustible> _registros = [];
  bool _loading = true;
  String? _filtroTipo; // null = todos, "combustible", "aceite"

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    try {
      final data = await HttpService.getListaCombustibles(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Combustible y Aceite"),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _filtroTipo = value!.isEmpty ? null : value);
              _cargar();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: '', child: Text("Todos")),
              const PopupMenuItem(
                value: "combustible",
                child: Text("Combustible"),
              ),
              const PopupMenuItem(value: "aceite", child: Text("Aceite")),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _registros.isEmpty
          ? const Center(child: Text("No hay registros aún."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _registros.length,
              itemBuilder: (context, index) {
                final r = _registros[index];
                final esCombustible = r.tipo == "combustible";
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: esCombustible
                          ? Colors.deepOrange
                          : Colors.blueGrey,
                      child: Icon(
                        esCombustible
                            ? Icons.local_gas_station
                            : Icons.oil_barrel,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      r.tipo.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${r.cantidad} ${r.unidad}  •  ${r.fecha}"),
                    trailing: Text(
                      "RD\$ ${FormatUtils.currency(r.monto)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
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
            '/combustible/registro',
            arguments: widget.vehiculoId,
          );
          _cargar(); // recargar al volver
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
