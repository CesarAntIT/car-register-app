import 'package:car_api_final_app/services/http_service.dart';
import 'package:car_api_final_app/widgets/my_temas_item.dart';
import 'package:flutter/material.dart';

class ForoMisTemasPage extends StatefulWidget {
  const ForoMisTemasPage({super.key});

  @override
  State<ForoMisTemasPage> createState() => _ForoMisTemasPageState();
}

class _ForoMisTemasPageState extends State<ForoMisTemasPage> {
  List<dynamic> _temas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    try {
      final data = await HttpService.getMisTemas().timeout(
        const Duration(seconds: 10),
      );
      setState(() {
        _temas = data['data'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Temas")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _temas.isEmpty
          ? const Center(child: Text("No has creado temas aún."))
          : RefreshIndicator(
              onRefresh: _cargar,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _temas.length,
                itemBuilder: (context, index) {
                  final t = _temas[index];
                  return MyTemasItem(t: t);
                },
              ),
            ),
    );
  }
}
