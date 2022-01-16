import 'dart:async';

import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc {
  //crear una unica instancia
  static final ScansBloc _singleton = new ScansBloc._internal();
// factory puede retornar una instancia o cualquier cosa
  factory ScansBloc() {
    return _singleton;
  }
  ScansBloc._internal() {
    //Obtener Scans de la Bdd
    //cuando se traiga la intancia traemos la informacion para q este cargada
    //se ejecuta y obtenemois otodos los cans
    obtenerScans();
  }

//varios lugares esuchan
//funciones o metodos de sacanmodel por eso el provider
  final _scansController = StreamController<List<ScanModel>>.broadcast();
  //q tipo de info de inf vs a flucir en el stream
  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  //cerrar la insancia
  dispose() {
    //validacion por si no tiene objetos (?)
    _scansController?.close();
  }

  obtenerScans() async {
    //agrergar algfo al flujo
    //await para espear q se resuelva y despues devuelve la lista de scanmodel q agregamos al sink
    _scansController.sink.add(await DBProvider.db.getTodosLosScans());
  }

  //agregar
  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    //avisar q hay un neuvo registro
    obtenerScans();
  }

  borrarScans(int id) async {
    await DBProvider.db.deleteScan(id);
    //obtener scan ejecuta el sink q consulta toda la bdd y trae la inf y lo adiciona al sccanController
    obtenerScans();
  }

  borrarScanTODOS() async {
    //va a la bdd y purga toda la inf. Espe4ramos a q todo suceda y luego optenemos los scans
    await DBProvider.db.deleteAllScans();
    obtenerScans();
    //o lopodemios hacer de esta forma porque  ya es seguro de q no hay registros adentro
    // _scansController.sink.add([]);
  }
}

//cuasnod lo llamemos de esta manera va a ejecutar el factory, el contructor
//final scansBloc = new ScansBloc();
