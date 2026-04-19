import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';

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

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final ok = await HttpService.registrarMantenimiento(
      vehiculoId: widget.vehiculoId,
      tipo: _tipo,
      costo: double.parse(_costoController.text),
      piezas: _piezasController.text,
      fecha: _fechaController.text,
    );

    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mantenimiento registrado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar el mantenimiento'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                style: const TextStyle(color: Colors.black),
                value: _tipo,
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

              // PIEZAS / DESCRIPCIÓN
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
              const SizedBox(height: 30),

              // BOTÓN GUARDAR
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
