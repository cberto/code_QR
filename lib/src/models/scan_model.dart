// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
import 'package:latlong/latlong.dart';

class ScanModel {
  int id;
  String tipo;
  String valor;

  ScanModel({
    this.id,
    this.tipo,
    this.valor,
  }) {
    //determinaicon
    if (valor.contains('http')) {
      this.tipo = 'http';
    } else {
      this.tipo = 'geo';
    }
  }
//crea una instancia
  factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
      );
//retornar objeto del mismo tipo
  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
      };
  //metodo q ayude a retornar l alatitud y longitud
  //s eejcuta cuando estamos tgrabvajando en un geolocaccion
  getLatLng() {
    //subtirng para conrtar
    final lalo = valor.substring(4).split(',');
    final lat = double.parse(lalo[0]);
    final lng = double.parse(lalo[1]);

    return LatLng(lat, lng);
  }
}
