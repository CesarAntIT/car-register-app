import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_page.dart';
import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void login() async {
    String matricula = matriculaController.text;
    String password = passwordController.text;

    if (matricula.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await AuthService.login(matricula, password);

    setState(() => isLoading = false);

    if (result != null && result["success"] == true) {
      String nombre = result["data"]["nombre"];
      String token = result["data"]["token"];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bienvenido $nombre")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(token: token),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenciales incorrectas")),
      );
    }
  }

  void recuperarClave() async {
    String matricula = matriculaController.text;

    if (matricula.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa tu matrícula")),
      );
      return;
    }

    bool ok = await AuthService.recuperarClave(matricula);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Clave temporal: 123456")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al recuperar clave")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "AUTOZONE",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: matriculaController,
              decoration: const InputDecoration(
                labelText: "Matrícula",
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
                : Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text("Iniciar Sesión"),
                  ),
                ),
                const SizedBox(height: 10),

                // RECUPERAR CONTRASEÑA
                TextButton(
                  onPressed: recuperarClave,
                  child: const Text("¿Olvidaste tu contraseña?"),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text("¿No tienes cuenta? Regístrate"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}