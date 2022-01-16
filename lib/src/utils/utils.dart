import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

abrirScan(BuildContext context, ScanModel scan) async {
//si es un sitio web
  if (scan.tipo == 'http') {
    //si se puede abrir lo lanzamos
    if (await canLaunch(scan.valor)) {
      await launch(scan.valor);
    } else {
      throw 'Could not launch ${scan.valor}';
    }
  } else {
    // print('GEO...');
    //mostrar la otra pantalla, como necesita el contexto lo greggamos en abirrScan el buildContext
    //mandamos los argumentos q recibimos de scan
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
