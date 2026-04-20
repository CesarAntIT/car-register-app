class GastoCategoria {
  final String valor;
  final String label;

  const GastoCategoria({required this.valor, required this.label});

  factory GastoCategoria.fromDynamic(dynamic data) {
    if (data is String) {
      return GastoCategoria(valor: data, label: data);
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final valor =
          (map['valor'] ??
                  map['value'] ??
                  map['categoria'] ??
                  map['slug'] ??
                  map['id'])
              .toString();
      final label =
          (map['label'] ??
                  map['nombre'] ??
                  map['descripcion'] ??
                  map['categoria'] ??
                  valor)
              .toString();

      return GastoCategoria(valor: valor, label: label);
    }

    return const GastoCategoria(valor: '', label: '');
  }
}
