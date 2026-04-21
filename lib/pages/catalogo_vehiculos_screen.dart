import 'package:car_api_final_app/models/vehiculo_model.dart';
import 'package:car_api_final_app/pages/login_page.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:car_api_final_app/services/profile_service.dart';
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
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  Future<void> _cargarVehiculos() async {
    final token = await HttpService.getToken();
    if (await ProfileService.getProfile(token ?? "") != null) {
      if(mounted) {
        setState(() {
        _futureVehiculos = service.getVehiculos();
        _isLoggedIn = true;
       });
      }
    }
  }

  Future _navegarYAnadir(BuildContext context, [Vehiculo? vehiculo]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioVehiculoScreen(vehiculo: vehiculo),
      ),
    );

    if (result == true) {
      await _cargarVehiculos();
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
          _isLoggedIn
              ? Expanded(
                  child: RefreshIndicator(
                    onRefresh: _cargarVehiculos,
                    child: FutureBuilder<List<Vehiculo>>(
                      future: _futureVehiculos,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error al cargar datos"),
                          );
                        }

                        final vehiculos = snapshot.data ?? [];

                        if (vehiculos.isEmpty) {
                          return Expanded(
                            child: const Center(
                              child: Text("No hay vehículos registrados"),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: vehiculos.length,
                          itemBuilder: (context, index) {
                            final v = vehiculos[index];
                            return VehicleListItem(v: v);
                          },
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 50),
                      Text("No aparece tu perfil?"),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        ),
                        child: Text("Inicia Sesión !!"),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _cargarVehiculos,
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 10),
          FloatingActionButton.large(
            heroTag: "add",
            backgroundColor: Colors.deepOrange,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _navegarYAnadir(context),
          ),
        ],
      ),
    );
  }
}