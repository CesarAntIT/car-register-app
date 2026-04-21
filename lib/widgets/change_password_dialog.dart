import 'package:car_api_final_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _actualController = TextEditingController();
  final TextEditingController _nuevaController = TextEditingController();
  bool _isLoading = false;

  void _confirmarCambio() async {
    if (_actualController.text.isEmpty || _nuevaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, llena ambos campos")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Llamada al método que creamos anteriormente
    bool exito = await AuthService.cambiarClave(
      _actualController.text,
      _nuevaController.text,
    );

    setState(() => _isLoading = false);

    if (exito) {
      if (mounted) Navigator.pop(context); // Cerrar pop-up
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contraseña actualizada con éxito")),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al cambiar la contraseña")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "CAMBIAR CONTRASEÑA",
        style: GoogleFonts.sairaStencilOne(color: Colors.deepOrange),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _actualController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Contraseña Actual",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _nuevaController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Nueva Contraseña",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text("CANCELAR"),
        ),
        _isLoading
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: _confirmarCambio,
                child: const Text("ACTUALIZAR"),
              ),
      ],
    );
  }
}