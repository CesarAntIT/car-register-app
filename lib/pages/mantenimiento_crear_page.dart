import 'dart:io';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MantenimientoCrearPage extends StatefulWidget {
  final int vehiculoId;
  const MantenimientoCrearPage({super.key, required this.vehiculoId});

  @override
  State<MantenimientoCrearPage> createState() => _MantenimientoCrearPageState();
}

class _MantenimientoCrearPageState extends State<MantenimientoCrearPage> {
  final _formKey = GlobalKey<FormState>();

  String _tipo = 'Preventivo';
  final _piezasController = TextEditingController();
  final _costoController = TextEditingController();
  final _fechaController = TextEditingController();
  bool _loading = false;

  final List<File> _fotos = [];
  final ImagePicker _picker = ImagePicker();
  final int _maxFotos = 5;

  final List<String> _tipos = [
    'Preventivo',
    'Correctivo',
    'Predictivo',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    final hoy = DateTime.now();
    _fechaController.text =
        '${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _piezasController.dispose();
    _costoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_fechaController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (fecha != null) {
      _fechaController.text =
          '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _agregarFoto() async {
    if (_fotos.length >= _maxFotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Máximo 5 fotos permitidas')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? img = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (img != null) setState(() => _fotos.add(File(img.path)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Cámara'),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? img = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (img != null) setState(() => _fotos.add(File(img.path)));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _eliminarFoto(int index) => setState(() => _fotos.removeAt(index));

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    // 1. Crear mantenimiento y obtener su id
    final mantenimientoId = await HttpService.registrarMantenimiento(
      vehiculoId: widget.vehiculoId,
      tipo: _tipo,
      costo: double.parse(_costoController.text),
      piezas: _piezasController.text,
      fecha: _fechaController.text,
    );

    if (mantenimientoId == null) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar el mantenimiento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. Subir fotos si hay
    if (_fotos.isNotEmpty) {
      await HttpService.subirFotosMantenimiento(
        mantenimientoId: mantenimientoId,
        rutasFotos: _fotos.map((f) => f.path).toList(),
      );
    }

    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mantenimiento registrado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Mantenimiento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TIPO
              const Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _tipo,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.build),
                ),
                items: _tipos
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _tipo = val!),
              ),
              const SizedBox(height: 16),

              // PIEZAS
              TextFormField(
                controller: _piezasController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Piezas / Descripción',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresa una descripción' : null,
              ),
              const SizedBox(height: 16),

              // COSTO
              TextFormField(
                controller: _costoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Costo (RD\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresa el costo' : null,
              ),
              const SizedBox(height: 16),

              // FECHA
              TextFormField(
                controller: _fechaController,
                readOnly: true,
                onTap: _seleccionarFecha,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Selecciona una fecha' : null,
              ),
              const SizedBox(height: 20),

              // FOTOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fotos (${_fotos.length}/$_maxFotos)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _agregarFoto,
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.deepOrange,
                    ),
                    label: const Text(
                      'Agregar',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  ),
                ],
              ),
              if (_fotos.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _fotos.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(_fotos[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _eliminarFoto(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 30),

              // GUARDAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _loading ? null : _guardar,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Guardar Mantenimiento',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
