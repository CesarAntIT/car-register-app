import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';

class IngresoRegistroPage extends StatefulWidget {
  final int vehiculoId;

  const IngresoRegistroPage({super.key, required this.vehiculoId});

  @override
  State<IngresoRegistroPage> createState() => _IngresoRegistroPageState();
}

class _IngresoRegistroPageState extends State<IngresoRegistroPage> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final _fechaController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fechaController.text =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_fechaController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected == null) return;

    _fechaController.text =
        '${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}';
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final ok = await HttpService.registrarIngreso(
      vehiculoId: widget.vehiculoId,
      concepto: _descripcionController.text.trim(),
      monto: double.parse(_montoController.text.trim()),
    );

    if (!mounted) return;

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Ingreso registrado exitosamente'
              : 'No se pudo registrar el ingreso',
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Ingreso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Concepto o descripcion',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa una descripcion';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _montoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Monto (RD\$)',
                  hintText: 'Ingresa el monto en pesos dominicanos (RD\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el monto';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Ingresa un monto valido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaController,
                readOnly: true,
                onTap: _seleccionarFecha,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Selecciona una fecha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _loading ? null : _guardar,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar ingreso'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
