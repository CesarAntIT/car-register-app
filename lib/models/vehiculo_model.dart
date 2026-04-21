class Vehiculo {
  final int? id;
  final String placa;
  final String chasis;
  final String marca;
  final String modelo;
  final int anio;
  final int cantidadRuedas;
  final String? fotoUrl;

  Vehiculo({
    this.id,
    required this.placa,
    required this.chasis,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.cantidadRuedas,
    this.fotoUrl,
  });

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id'],
      placa: json['placa'] ?? '',
      chasis: json['chasis'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      anio: json['anio'] ?? 0,
      // IMPORTANTE: La API usa guiones bajos en el GET
      cantidadRuedas: json['cantidad_ruedas'] ?? json['cantidadRuedas'] ?? 0,
      fotoUrl: json['foto_url'] ?? json['fotoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placa': placa,
      'chasis': chasis,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'cantidadRuedas': cantidadRuedas,
    };
  }
}
