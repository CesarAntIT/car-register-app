import 'package:flutter/material.dart';
import '../services/vehiculo_service.dart';

class ResumenPage extends StatefulWidget {
  final String token;
  final int vehiculoId;

  const ResumenPage({
    super.key,
    required this.token,
    required this.vehiculoId,
  });

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
    final data =
    await VehiculoService.getDetalle(widget.token, widget.vehiculoId);

    setState(() {
      resumen = data?["data"]?["resumen"];
    });
  }

  Widget item(String title, dynamic value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(value.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (resumen == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
          ],
        ),
      ),
    );
  }
}