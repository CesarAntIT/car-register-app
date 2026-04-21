class Owner {
  final String nombre;
  final String matricula;
  final String? correo;
  final String? fotoUrl;

  Owner({
    required this.nombre,
    required this.matricula,
    this.correo,
    this.fotoUrl,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      nombre: json['nombre'],
      matricula: json['matricula'],
      correo: json['correo'],
      fotoUrl: json['fotoUrl'],
    );
  }

  factory Owner.fromFlatData(String nombre, String matricula, String? fotoUrl) {
    return Owner(nombre: nombre, matricula: matricula, fotoUrl: fotoUrl);
  }
}

class Stats {
  final int mantenimientos;
  final double costoMantenimientos;
  final int cargas;
  final double costoCombustible;
  final int gomas;
  final int gomasBuenas;

  Stats({
    required this.mantenimientos,
    required this.costoMantenimientos,
    required this.cargas,
    required this.costoCombustible,
    required this.gomas,
    required this.gomasBuenas,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      mantenimientos: json['mantenimientos'],
      // Usamos .toDouble() por si el API manda enteros
      costoMantenimientos: (json['costoMantenimientos'] as num).toDouble(),
      cargas: json['cargas'],
      costoCombustible: (json['costoCombustible'] as num).toDouble(),
      gomas: json['gomas'],
      gomasBuenas: json['gomasBuenas'],
    );
  }
}

class Catalogo {
  final int id;
  final String placa;
  final String chasis;
  final String marca;
  final String modelo;
  final int anio;
  final int cantidadRuedas;
  final String? fotoUrl;
  final String fechaRegistro;
  final Owner owner;
  final Stats? stats;

  Catalogo({
    required this.id,
    required this.placa,
    required this.chasis,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.cantidadRuedas,
    this.fotoUrl,
    required this.fechaRegistro,
    required this.owner,
    this.stats,
  });

  factory Catalogo.fromMap(Map<String, dynamic> json) {
    // 1. Manejo seguro del Owner
    Owner parsedOwner;
    if (json['owner'] is Map) {
      parsedOwner = Owner.fromJson(json['owner']);
    } else {
      parsedOwner = Owner.fromFlatData(
        json['owner']?.toString() ?? 'Sin nombre', // ?. y ?? evitan el error
        json['ownerMatricula']?.toString() ?? 'Sin matrícula',
        json['ownerFotoUrl']?.toString(),
      );
    }

    return Catalogo(
      id: json['id'] ?? 0,
      placa: json['placa']?.toString() ?? "S/P",
      chasis: json['chasis'].toString(),
      marca: json['marca']?.toString() ?? "Genérica",
      modelo: json['modelo']?.toString() ?? "Desconocido",
      anio: json['anio'] ?? 0,
      cantidadRuedas: json['cantidadRuedas'] ?? json['cantidad_ruedas'] ?? 0,
      fotoUrl: json['fotoUrl']?.toString(),
      fechaRegistro:
          json['fechaRegistro'] ??
          json['fecha_registro'] ??
          "Fecha no disponible",
      owner: parsedOwner,
      stats: json['stats'] != null ? Stats.fromJson(json['stats']) : null,
    );
  }
}
