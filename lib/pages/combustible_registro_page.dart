import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';

class CombustibleRegistroPage extends StatefulWidget {
  final int vehiculoId;
  const CombustibleRegistroPage({super.key, required this.vehiculoId});

  @override
  State<CombustibleRegistroPage> createState() =>
      _CombustibleRegistroPageState();
}

class _CombustibleRegistroPageState extends State<CombustibleRegistroPage> {
  final _formKey = GlobalKey<FormState>();
  String _tipo = "combustible";
  String _unidad = "galones";
  final _cantidadController = TextEditingController();
  final _montoController = TextEditingController();
  bool _loading = false;

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final ok = await HttpService.registrarCombustible(
      vehiculoId: widget.vehiculoId,
      tipo: _tipo,
      cantidad: double.parse(_cantidadController.text),
      unidad: _unidad,
      monto: double.parse(_montoController.text),
    );

    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registro guardado exitosamente"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al guardar el registro"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Carga")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TIPO
              const Text("Tipo", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: "combustible",
                    label: Text("Combustible"),
                    icon: Icon(Icons.local_gas_station),
                  ),
                  ButtonSegment(
                    value: "aceite",
                    label: Text("Aceite"),
                    icon: Icon(Icons.oil_barrel),
                  ),
                ],
                selected: {_tipo},
                onSelectionChanged: (val) =>
                    setState(() {
                      _tipo = val.first;
                      _unidad = _tipo == "aceite" ? "qt" : "galones";
                    }),
              ),
              const SizedBox(height: 20),

              // CANTIDAD
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Cantidad",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingresa la cantidad" : null,
              ),
              const SizedBox(height: 16),

              // UNIDAD
              const Text("Unidad", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _unidad,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: "galones", child: Text("Galones")),
                  DropdownMenuItem(value: "litros", child: Text("Litros")),
                  DropdownMenuItem(value: "qt", child: Text("Qt")),
                ],
                onChanged: (val) => setState(() => _unidad = val!),
              ),
              const SizedBox(height: 16),

              // MONTO
              TextFormField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Monto (RD\$)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingresa el monto" : null,
              ),
              const SizedBox(height: 30),

              // BOTÓN
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
                      : const Text("Guardar Registro",
                          style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}