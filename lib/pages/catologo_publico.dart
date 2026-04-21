import 'package:car_api_final_app/models/catalogo_models.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:car_api_final_app/widgets/catalogo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Importa tus modelos y servicios
// import 'package:tu_app/models/vehiculo.dart';
// import 'package:tu_app/services/vehiculo_service.dart';

class CatalogoPublico extends StatefulWidget {
  const CatalogoPublico({super.key});

  @override
  State<CatalogoPublico> createState() => _CatalogoPublicoState();
}

class _CatalogoPublicoState extends State<CatalogoPublico> {
  final TextEditingController _searchController = TextEditingController();
  int _paginaActual = 1;
  String _filtro = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setSearch(String value) {
    if (mounted) {
      setState(() {
        _filtro = value;
        _paginaActual = 1;
      });
    }
  }

  void _clearSearch() {
    if (mounted) {
      _searchController.clear();
      setState(() {
        _filtro = "";
        _paginaActual = 1;
      });
    }
  }

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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar por placa, marca y dueño",
                prefixIcon: const Icon(Icons.search, color: Colors.deepOrange),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _clearSearch(),
                ),
              ),
              onSubmitted: (value) => _setSearch(value),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Catalogo>>(
              future: HttpService.listarCatalogo(_filtro, _paginaActual),
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

                final catalogo = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: catalogo.length + 1,
                  itemBuilder: (context, index) {
                    if (index < catalogo.length) {
                      return CatalogoListItem(vehiculo: catalogo[index]);
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _paginaActual == 1
                                  ? SizedBox()
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            _paginaActual--;
                                          });
                                        }
                                      },
                                      child: Text(
                                        "-",
                                        style: Theme.of(
                                          context,
                                        ).appBarTheme.titleTextStyle,
                                      ),
                                    ),
                              Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.deepOrangeAccent[100],
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Text(
                                  "$_paginaActual",
                                  style: Theme.of(
                                    context,
                                  ).appBarTheme.titleTextStyle,
                                ),
                              ),
                              catalogo.length < 20
                                  ? SizedBox()
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            _paginaActual++;
                                          });
                                        }
                                      },
                                      child: Text(
                                        "+",
                                        style: Theme.of(
                                          context,
                                        ).appBarTheme.titleTextStyle,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    }
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
