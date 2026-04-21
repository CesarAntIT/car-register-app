import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/material.dart';

class ForoCrearTemaPage extends StatefulWidget {
  final int vehiculoId;
  const ForoCrearTemaPage({super.key, required this.vehiculoId});

  @override
  State<ForoCrearTemaPage> createState() => _ForoCrearTemaPageState();
}

class _ForoCrearTemaPageState extends State<ForoCrearTemaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  bool _loading = false;

  Future<void> _publicar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final ok = await HttpService.crearTemaForo(
      vehiculoId: widget.vehiculoId,
      titulo: _tituloController.text.trim(),
      descripcion: _descripcionController.text.trim(),
    );

    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tema publicado exitosamente"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al publicar. Verifica que tu vehículo tenga foto."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Tema en el Foro")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "⚠️ Tu vehículo debe tener foto para publicar en el foro.",
                style: TextStyle(color: Colors.orange),
              ),
              const SizedBox(height: 20),

              // TÍTULO
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                maxLength: 100,
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingresa un título" : null,
              ),
              const SizedBox(height: 16),

              // DESCRIPCIÓN
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                maxLength: 500,
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingresa una descripción" : null,
              ),
              const SizedBox(height: 30),

              // BOTÓN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _loading ? null : _publicar,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: const Text("Publicar Tema",
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