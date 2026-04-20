import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'activate_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController matriculaController = TextEditingController();

  void register() async {
    final result =
    await AuthService.registro(matriculaController.text);

    if (result != null) {
      String token = result["data"]["token"];

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Token de activación"),
            content: SelectableText(token),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ActivatePage(),
                    ),
                  );
                },
                child: const Text("Continuar"),
              )
            ],
          );
        },
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Token de activación"),
            content: SelectableText(token),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          );
        },
      );

      // luego vas a activación
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error en registro")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: matriculaController,
              decoration: const InputDecoration(
                labelText: "Matrícula",
              ),
            ),
            ElevatedButton(
              onPressed: register,
              child: const Text("Registrarse"),
            )
          ],
        ),
      ),
    );
  }
}