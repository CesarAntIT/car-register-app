import 'package:car_api_final_app/models/vehiculo_model.dart';
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

  Future<void> _navegarYActualizar(
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
      body: FutureBuilder<List<Vehiculo>>(
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
            return const Center(child: Text("No hay vehículos registrados"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: vehiculos.length,
            itemBuilder: (context, index) {
              final v = vehiculos[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: (v.fotoUrl != null && v.fotoUrl!.isNotEmpty)
                        ? Image.network(
                            v.fotoUrl!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.directions_car,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.directions_car,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  title: Text(
                    "${v.marca} ${v.modelo} (${v.anio})",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Placa: ${v.placa}\nChasis: ${v.chasis}"),
                  isThreeLine: true,
                  trailing: const Icon(Icons.edit, color: Colors.deepOrange),
                  onTap: () => _navegarYActualizar(context, v),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navegarYActualizar(context),
      ),
    );
  }
}
