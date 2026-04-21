import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';
import '../services/vehiculo_service.dart';

class ResumenPage extends StatefulWidget {
  final int vehiculoId;

  const ResumenPage({super.key, required this.vehiculoId});

  @override
  State<ResumenPage> createState() => _ResumenPageState();
}

class _ResumenPageState extends State<ResumenPage> {
  Map<String, dynamic>? resumen;

  @override
  void initState() {
    super.initState();
    loadResumen();
  }

  void loadResumen() async {
    final token = await HttpService.getToken() ?? "";
    final data = await VehiculoService.getDetalle(token, widget.vehiculoId);

    setState(() {
      resumen = data?["data"]?["resumen"];
    });
  }

  Widget item(String title, dynamic value) {
    return Card(
      child: ListTile(title: Text(title), trailing: Text(value.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (resumen == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Resumen Financiero")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            item("Total Gastos", resumen!["totalGastos"]),
            item("Total Ingresos", resumen!["totalIngresos"]),
            item("Total Invertido", resumen!["totalInvertido"]),
            item("Balance", resumen!["balance"]),
            Wrap(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      '/combustible',
                      arguments: widget.vehiculoId,
                    );
                  },
                  label: Text("Combustibles"),
                  icon: Icon(Icons.local_gas_station),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      '/mantenimiento',
                      arguments: widget.vehiculoId,
                    );
                  },
                  label: Text("Mantenimiento"),
                  icon: Icon(Icons.build),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      '/finanzas',
                      arguments: widget.vehiculoId,
                    );
                  },
                  label: Text("Registrar Gastos y Ingresos"),
                  icon: Icon(Icons.build),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
