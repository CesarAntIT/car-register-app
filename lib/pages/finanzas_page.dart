import 'package:car_api_final_app/models/movimiento_financiero_model.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:car_api_final_app/utils/format_utils.dart';
import 'package:flutter/material.dart';

class FinanzasPage extends StatefulWidget {
  final int vehiculoId;

  const FinanzasPage({super.key, required this.vehiculoId});

  @override
  State<FinanzasPage> createState() => _FinanzasPageState();
}

class _FinanzasPageState extends State<FinanzasPage> {
  int _tabIndex = 0;

  List<MovimientoFinanciero> _gastos = [];
  List<MovimientoFinanciero> _ingresos = [];

  int _gastosPage = 1;
  int _ingresosPage = 1;

  bool _loadingGastos = true;
  bool _loadingIngresos = true;
  bool _hasMoreGastos = true;
  bool _hasMoreIngresos = true;

  bool _isUSD = false;

  @override
  void initState() {
    super.initState();
    _cargarInicial();
  }

  Future<void> _cargarInicial() async {
    await Future.wait([
      _cargarGastos(reset: true),
      _cargarIngresos(reset: true),
    ]);
  }

  Future<void> _cargarGastos({bool reset = false}) async {
    final nextPage = reset ? 1 : _gastosPage;

    setState(() => _loadingGastos = true);

    final res = await HttpService.getListaGastos(
      widget.vehiculoId,
      page: nextPage,
    );

    final items = res['items'] as List<MovimientoFinanciero>;
    final hasMore = res['hasMore'] as bool;

    if (!mounted) return;

    setState(() {
      _gastos = reset ? items : [..._gastos, ...items];
      _gastosPage = nextPage + 1;
      _hasMoreGastos = hasMore;
      _loadingGastos = false;
    });
  }

  Future<void> _cargarIngresos({bool reset = false}) async {
    final nextPage = reset ? 1 : _ingresosPage;

    setState(() => _loadingIngresos = true);

    final res = await HttpService.getListaIngresos(
      widget.vehiculoId,
      page: nextPage,
    );

    final items = res['items'] as List<MovimientoFinanciero>;
    final hasMore = res['hasMore'] as bool;

    if (!mounted) return;

    setState(() {
      _ingresos = reset ? items : [..._ingresos, ...items];
      _ingresosPage = nextPage + 1;
      _hasMoreIngresos = hasMore;
      _loadingIngresos = false;
    });
  }

  Future<void> _abrirRegistroActual() async {
    final route = _tabIndex == 0 ? '/finanzas/gasto' : '/finanzas/ingreso';
    await Navigator.pushNamed(context, route, arguments: widget.vehiculoId);
    if (_tabIndex == 0) {
      _cargarGastos(reset: true);
    } else {
      _cargarIngresos(reset: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mostrandoGastos = _tabIndex == 0;
    final items = mostrandoGastos ? _gastos : _ingresos;
    final loading = mostrandoGastos ? _loadingGastos : _loadingIngresos;
    final hasMore = mostrandoGastos ? _hasMoreGastos : _hasMoreIngresos;

    return Scaffold(
      appBar: AppBar(title: const Text('Gastos e Ingresos')),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Gastos')),
                    ButtonSegment(value: 1, label: Text('Ingresos')),
                  ],
                  selected: {_tabIndex},
                  onSelectionChanged: (values) {
                    setState(() => _tabIndex = values.first);
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => mostrandoGastos
                      ? _cargarGastos(reset: true)
                      : _cargarIngresos(reset: true),
                  child: loading && items.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 220),
                            Center(child: CircularProgressIndicator()),
                          ],
                        )
                      : items.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: 180),
                            Center(
                              child: Text(
                                mostrandoGastos
                                    ? 'No hay gastos registrados.'
                                    : 'No hay ingresos registrados.',
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 90),
                          itemCount: items.length + (hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == items.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: OutlinedButton.icon(
                                  onPressed: mostrandoGastos
                                      ? () => _cargarGastos()
                                      : () => _cargarIngresos(),
                                  icon: const Icon(Icons.expand_more),
                                  label: const Text('Cargar mas'),
                                ),
                              );
                            }

                            final item = items[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: mostrandoGastos
                                      ? Colors.red.shade100
                                      : Colors.green.shade100,
                                  child: Icon(
                                    mostrandoGastos
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: mostrandoGastos
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                title: Text(
                                  item.descripcion,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  [
                                    if ((item.categoria ?? '').isNotEmpty)
                                      item.categoria!,
                                    item.fecha,
                                  ].join('  •  '),
                                ),
                                trailing: Text(
                                  _isUSD
                                      ? 'US\$ ${FormatUtils.currency(item.monto / 61.95)}'
                                      : 'RD\$ ${FormatUtils.currency(item.monto)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: mostrandoGastos
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton.small(
              heroTag: 'currency_toggle',
              onPressed: () => setState(() => _isUSD = !_isUSD),
              backgroundColor: Colors.white,
              child: Image.asset(
                _isUSD ? 'assets/images/USA.png' : 'assets/images/RD.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        onPressed: _abrirRegistroActual,
        heroTag: 'register',
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          mostrandoGastos ? 'Agregar gasto' : 'Agregar ingreso',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
