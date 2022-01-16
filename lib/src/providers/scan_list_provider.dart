import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';
class ScanListProvider extends ChangeNotifier{
  List<ScanModel> scans=[];
  //seleccionadas iocion
  String tipoSeleccionado ='http';
    Future<ScanModel> nuevoScan( String valor ) async {

    final nuevoScan = new ScanModel(valor: valor);
    //insertar en bdd, scan a insertar,regresa el id del regstro insertado
    final id = await DBProvider.db.nuevoScan(nuevoScan);
    // Asignar el ID de la base de datos al modelo
    nuevoScan.id = id;
//si son del mismo tipo
    if ( this.tipoSeleccionado == nuevoScan.tipo ) {
      //insertar el scan
      this.scans.add(nuevoScan);
      //notificar cuanod hay un cambio q hay q redibujarse
      notifyListeners();
    }

    return nuevoScan;
  }
  cargarScans() async {
    final scans = await DBProvider.db.getTodosLosScans();
    //asigamos al scan vacio un nuevo listado, lo reemplazamos
    this.scans = [...scans];
    //para q se actualice la pantalla
    notifyListeners();
  }

  cargarScanPorTipo( String tipo ) async {
    //interaccion de la bdd
    final scans = await DBProvider.db.getScansPorTipo(tipo);
    this.scans = [...scans];
    this.tipoSeleccionado = tipo;
    notifyListeners();
  }

  borrarTodos() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    //notificar q los scans este vacio
    notifyListeners();
  }

  borrarScanPorId( int id ) async {
    await DBProvider.db.deleteScan(id);
    this.cargarScanPorTipo(this.tipoSeleccionado);
  }
}