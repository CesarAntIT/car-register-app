import 'package:car_api_final_app/services/http_service.dart';
import 'package:car_api_final_app/widgets/foro_list_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForoListaPage extends StatefulWidget {
  const ForoListaPage({super.key});

  @override
  State<ForoListaPage> createState() => _ForoListaPageState();
}

class _ForoListaPageState extends State<ForoListaPage> {
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
      final data = await HttpService.getListaTemasForo().timeout(
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
      appBar: AppBar(
        title: Text("Foro Comunitario", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks),
            onPressed: () => Navigator.pushNamed(context, '/foro/mis-temas'),
            tooltip: "Mis temas",
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _temas.isEmpty
          ? const Center(child: Text("No hay temas aún."))
          : RefreshIndicator(
              onRefresh: _cargar,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _temas.length,
                itemBuilder: (context, index) {
                  final t = _temas[index];
                  return ForoListItem(t: t);
                },
              ),
            ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Colors.deepOrange,
      //   foregroundColor: Colors.white,
      //   onPressed: () async {
      //     await Navigator.pushNamed(
      //       context,
      //       '/foro/crear',
      //       arguments: 24, // vehiculoId — cuando haya login, pasar el real
      //     );
      //     _cargar();
      //   },
      //   icon: const Icon(Icons.add),
      //   label: const Text("Nuevo Tema"),
      // ),
    );
  }
}
