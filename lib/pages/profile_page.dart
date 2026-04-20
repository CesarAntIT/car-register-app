import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import 'resumen_page.dart';

class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    final data = await ProfileService.getProfile(widget.token);
    setState(() => profile = data);
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = profile!["data"];

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // FOTO
            CircleAvatar(
              radius: 50,
              backgroundImage: user["fotoUrl"] != null &&
                  user["fotoUrl"].toString().isNotEmpty
                  ? NetworkImage(user["fotoUrl"])
                  : null,
              child: user["fotoUrl"] == null ||
                  user["fotoUrl"].toString().isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            const SizedBox(height: 15),

            // NOMBRE
            Text(
              "${user["nombre"]} ${user["apellido"]}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 5),

            Text(
              user["correo"] ?? "",
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // 🔥 TARJETAS
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge),
                title: const Text("Matrícula"),
                subtitle: Text(user["matricula"] ?? ""),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.group),
                title: const Text("Grupo"),
                subtitle: Text(user["grupo"] ?? "N/A"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.security),
                title: const Text("Rol"),
                subtitle: Text(user["rol"] ?? "Usuario"),
              ),
            ),

            const SizedBox(height: 25),

            // BOTÓN RESUMEN FINANCIERO
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResumenPage(
                        token: widget.token,
                        vehiculoId: 1,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.bar_chart),
                label: const Text("Ver Resumen Financiero"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}