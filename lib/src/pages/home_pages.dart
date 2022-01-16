import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/blog/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

//import 'package:qrreaderapp/src/models/scan_model.dart';
//import 'package:barcode_scan/barcode_scan.dart';

//StalessFuldWidget para q sea de manera dinamica,cual es el estado del valor de la pagina actual
//StatefulWidget maneja estados
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),

            //lamamos le metod de scanBloc para borrar todos
            onPressed: scansBloc.borrarScanTODOS,
          )
        ],
      ),
      body: _cargarPagina(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  //llamamos al metodo
  _scanQR(BuildContext context) async {
    //https://www.ijf.org/
//geo:37.38420646921762,139.69462022343745

    // dynamic futureString = 'https://www.ijf.org/';
    String futureString = 'https://www.ijf.org/';
    //   try {
    //     futureString = await BarcodeScanner.scan();
// } catch (e) {
    //     futureString = e.toString();
    //   }

    //   print('Future String: ${futureString.rawContent}');

    if (futureString != null) {
      //print('Tenemos informacion');
      final scan = ScanModel(valor: futureString);
      //usamos la otra intancia
      scansBloc.agregarScan(scan);
      // DBProvider.db.nuevoScan(scan);

      final scan2 =
          ScanModel(valor: 'geo:37.38420646921762,139.69462022343745');
      scansBloc.agregarScan(scan2);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          //mandamos en ambos el context
          utils.abrirScan(context, scan);
        });
      } else {
        utils.abrirScan(context, scan);
      }

      // utils.abrirScan(scan);
    }
  }

  Widget _cargarPagina(int paginaActual) {
    //evaluamos donde estamos,
    //evaluamos la apgina actual
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      //en caso de q no  reciba
      default:
        return MapasPage();
    }
  }

  Widget _crearBottomNavigationBar() {
    //crear opciones
    return BottomNavigationBar(
      //q elementos esat activo
      currentIndex: currentIndex,
      //dispara cuando se seleccione
      //le pasamos el index para q vaya cambiando
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Mapas')),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), title: Text('Direcciones'))
      ],
    );
  }
}
