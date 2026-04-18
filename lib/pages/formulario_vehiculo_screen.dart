import 'dart:io';
import 'package:car_api_final_app/models/vehiculo_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/vehiculo_service.dart';

class FormularioVehiculoScreen extends StatefulWidget {
  final Vehiculo? vehiculo;

  const FormularioVehiculoScreen({super.key, this.vehiculo});

  @override
  State<FormularioVehiculoScreen> createState() =>
      _FormularioVehiculoScreenState();
}

class _FormularioVehiculoScreenState extends State<FormularioVehiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = VehiculoService();

  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _anioController;
  late TextEditingController _placaController;
  late TextEditingController _chasisController;
  late TextEditingController _ruedasController;

  bool _isLoading = false;
  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController(
      text: widget.vehiculo?.marca ?? '',
    );
    _modeloController = TextEditingController(
      text: widget.vehiculo?.modelo ?? '',
    );
    _anioController = TextEditingController(
      text: widget.vehiculo?.anio.toString() ?? '',
    );
    _placaController = TextEditingController(
      text: widget.vehiculo?.placa ?? '',
    );
    _chasisController = TextEditingController(
      text: widget.vehiculo?.chasis ?? '',
    );
    _ruedasController = TextEditingController(
      text: widget.vehiculo?.cantidadRuedas.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    _placaController.dispose();
    _chasisController.dispose();
    _ruedasController.dispose();
    super.dispose();
  }

  void _mostrarOpcionesImagen() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() => _imagenSeleccionada = File(image.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() => _imagenSeleccionada = File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _guardarVehiculo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final vehiculoData = Vehiculo(
      id: widget.vehiculo?.id,
      marca: _marcaController.text,
      modelo: _modeloController.text,
      anio: int.parse(_anioController.text),
      placa: _placaController.text,
      chasis: _chasisController.text,
      cantidadRuedas: int.parse(_ruedasController.text),
    );

    try {
      bool success;
      if (widget.vehiculo == null) {
        success = await _service.createVehiculo(
          vehiculoData,
          foto: _imagenSeleccionada,
        );
      } else {
        success = await _service.updateVehiculo(
          widget.vehiculo!.id!,
          vehiculoData,
          foto: _imagenSeleccionada,
        );
      }

      if (success && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Operación exitosa')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vehiculo == null ? "Crear Vehículo" : "Editar Vehículo",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _mostrarOpcionesImagen,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: _imagenSeleccionada != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              _imagenSeleccionada!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : (widget.vehiculo?.fotoUrl != null &&
                              widget.vehiculo!.fotoUrl!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.vehiculo!.fotoUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Foto\n(Opcional)',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _anioController,
                decoration: const InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (int.tryParse(value) == null)
                    return 'Debe ser un número válido';
                  return null;
                },
              ),
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _chasisController,
                decoration: const InputDecoration(labelText: 'Chasis'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _ruedasController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad de Ruedas',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (int.tryParse(value) == null)
                    return 'Debe ser un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (widget.vehiculo != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Combustibles"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          '/foro/crear',
                          arguments: widget
                              .vehiculo!
                              .id, // vehiculoId — cuando haya login, pasar el real
                        );
                      },
                      child: Text("Crear Tema"),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _guardarVehiculo,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
