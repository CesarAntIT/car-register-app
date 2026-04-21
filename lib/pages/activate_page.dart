import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ActivatePage extends StatefulWidget {
  const ActivatePage({super.key});

  @override
  State<ActivatePage> createState() => _ActivatePageState();
}

class _ActivatePageState extends State<ActivatePage> {
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void activar() async {
    String token = tokenController.text;
    String password = passwordController.text;

    if (token.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => isLoading = true);

    bool success = await AuthService.activar(token, password);

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuenta activada")),
      );

      Navigator.pop(context); // vuelve al login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al activar cuenta")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Activar Cuenta")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: tokenController,
              decoration: const InputDecoration(
                labelText: "Token",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: activar,
                child: const Text("Activar Cuenta"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}