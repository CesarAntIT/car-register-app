import 'package:car_api_final_app/models/catalogo_models.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Importa tus modelos y servicios
// import 'package:tu_app/models/vehiculo.dart';
// import 'package:tu_app/services/vehiculo_service.dart';

class DetalleCatalogo extends StatelessWidget {
  final int vehiculoId;

  const DetalleCatalogo({super.key, required this.vehiculoId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Catalogo?>(
      future: HttpService.detalleCatalogo(vehiculoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(
              child: Text("No se pudo cargar el detalle del vehículo"),
            ),
          );
        }

        final vehiculo = snapshot.data!;

        return Scaffold(
          // Título con Marca y Modelo
          appBar: AppBar(title: Text("${vehiculo.marca} ${vehiculo.modelo}")),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen principal del vehículo
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: vehiculo.fotoUrl != null
                      ? Image.network(vehiculo.fotoUrl!, fit: BoxFit.cover)
                      : const Icon(
                          Icons.directions_car,
                          size: 100,
                          color: Colors.white,
                        ),
                ),

                // Información General
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    "Información General",
                    style: GoogleFonts.interTight(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _buildInfoCard(context, [
                  _buildInfoRow(
                    Icons.confirmation_number,
                    "Placa",
                    vehiculo.placa,
                  ),
                  _buildInfoRow(
                    Icons.settings_input_component,
                    "Chasis",
                    vehiculo.chasis,
                  ),
                  _buildInfoRow(
                    Icons.calendar_today,
                    "Año",
                    vehiculo.anio.toString(),
                  ),
                  _buildInfoRow(
                    Icons.tire_repair,
                    "Ruedas",
                    vehiculo.cantidadRuedas.toString(),
                  ),
                ]),

                // Propietario
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    "Datos del Dueño",
                    style: GoogleFonts.interTight(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _buildOwnerCard(context, vehiculo.owner),

                // Estadísticas (solo si existen)
                if (vehiculo.stats != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      "Estadisticas de Uso",
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  _buildStatsGrid(context, vehiculo.stats!),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widgets Auxiliares

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.deepOrange),
          const SizedBox(width: 15),
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildOwnerCard(BuildContext context, Owner owner) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(owner.fotoUrl ?? ""),
          backgroundColor: Colors.deepOrange,
        ),
        title: Text(
          owner.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${owner.matricula}\n${owner.correo ?? ''}"),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, Stats stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildStatTile(
          "Mantenimientos",
          stats.mantenimientos.toString(),
          Icons.build,
        ),
        _buildStatTile(
          "Gastos Mant.",
          "\$${stats.costoMantenimientos}",
          Icons.monetization_on,
        ),
        _buildStatTile(
          "Cargas Comb.",
          stats.cargas.toString(),
          Icons.local_gas_station,
        ),
        _buildStatTile(
          "Gomas Buenas",
          "${stats.gomasBuenas}/${stats.gomas}",
          Icons.trip_origin,
        ),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrange[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.deepOrange.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.deepOrange, size: 18),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
