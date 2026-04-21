import 'package:car_api_final_app/models/catalogo_models.dart';
import 'package:car_api_final_app/pages/catalogo_publico_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatalogoListItem extends StatelessWidget {
  const CatalogoListItem({super.key, required this.vehiculo});
  final Catalogo vehiculo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleCatalogo(vehiculoId: vehiculo.id),
          ),
        );
        print("Ver detalle de: ${vehiculo.id}");
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Etiqueta de la Placa (Estilo Categoría)
              Text(
                " PLACA: ${vehiculo.placa}",
                style: GoogleFonts.interTight(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${vehiculo.marca} ${vehiculo.modelo}",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        Text(
                          "Año: ${vehiculo.anio}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  // Imagen del Vehículo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: vehiculo.fotoUrl != null
                        ? Image.network(
                            vehiculo.fotoUrl!,
                            width: 120,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 120,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.directions_car),
                                ),
                          )
                        : Container(
                            width: 120,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                ],
              ),
              const Divider(),
              // Datos del dueño (Estilo descripción)
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(vehiculo.owner.fotoUrl ?? ""),
                    backgroundColor: Colors.deepOrange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dueño: \n${vehiculo.owner.nombre}",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                          softWrap:
                              true, // Permite que el texto baje a la siguiente línea
                          maxLines:
                              2, // Limita a 2 líneas para no romper la estética
                          overflow: TextOverflow
                              .visible, // O usa ellipsis si prefieres cortar
                        ),
                        Text(
                          "Matrícula: ${vehiculo.owner.matricula}",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.deepOrange,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    vehiculo.fechaRegistro.split(' ')[0], // Solo la fecha
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
