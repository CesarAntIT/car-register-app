import 'package:car_api_final_app/models/vehiculo_model.dart';
import 'package:car_api_final_app/pages/formulario_vehiculo_screen.dart';
import 'package:flutter/material.dart';

class VehicleListItem extends StatelessWidget {
  const VehicleListItem({super.key, required this.v});

  final Vehiculo v;

  Future<void> _navegarYActualizar(
    BuildContext context, [
    Vehiculo? vehiculo,
  ]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioVehiculoScreen(vehiculo: vehiculo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.directions_car, color: Colors.grey),
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.directions_car, color: Colors.grey),
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
  }
}
