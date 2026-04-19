import 'package:car_api_final_app/models/vehiculo_model.dart';
import 'package:car_api_final_app/widgets/vehicle_list_item.dart';
import 'package:flutter/material.dart';
import '../services/vehiculo_service.dart';
import 'formulario_vehiculo_screen.dart';

class CatalogoVehiculosScreen extends StatefulWidget {
  const CatalogoVehiculosScreen({super.key});

  @override
  State<CatalogoVehiculosScreen> createState() =>
      _CatalogoVehiculosScreenState();
}

class _CatalogoVehiculosScreenState extends State<CatalogoVehiculosScreen> {
  final VehiculoService service = VehiculoService();
  late Future<List<Vehiculo>> _futureVehiculos;

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  void _cargarVehiculos() {
    setState(() {
      _futureVehiculos = service.getVehiculos();
    });
  }

  Future<void> _navegarYAnadir(
    BuildContext context, [
    Vehiculo? vehiculo,
  ]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioVehiculoScreen(vehiculo: vehiculo),
      ),
    );

    if (result == true) {
      _cargarVehiculos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "  Mis Vehiculos",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          Divider(),
          FutureBuilder<List<Vehiculo>>(
            future: _futureVehiculos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Error al cargar datos"));
              }

              final vehiculos = snapshot.data ?? [];

              if (vehiculos.isEmpty) {
                return const Center(
                  child: Text("No hay vehículos registrados"),
                );
              }

              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: vehiculos.length,
                  itemBuilder: (context, index) {
                    final v = vehiculos[index];
                    return VehicleListItem(v: v);
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navegarYAnadir(context),
      ),
    );
  }
}
