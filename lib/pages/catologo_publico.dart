import 'package:car_api_final_app/models/catalogo_models.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:car_api_final_app/widgets/catalogo_list_item.dart';
import 'package:flutter/material.dart';
// Importa tus modelos y servicios
// import 'package:tu_app/models/vehiculo.dart';
// import 'package:tu_app/services/vehiculo_service.dart';

class CatalogoPublico extends StatefulWidget {
  const CatalogoPublico({super.key});

  @override
  State<CatalogoPublico> createState() => _CatalogoPublicoState();
}

class _CatalogoPublicoState extends State<CatalogoPublico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "  Catalogo de Vehiculos",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          Divider(),
          Expanded(
            child: FutureBuilder<List<Catalogo>>(
              future: HttpService.listarCatalogo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Hubo un Error al cargar los vehiculos del Catalogo",
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No hay vehiculos dentro del Catalogo"),
                  );
                }

                final vehiculos = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: vehiculos.length,
                  itemBuilder: (context, index) {
                    return CatalogoListItem(vehiculo: vehiculos[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
