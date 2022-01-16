import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/blog/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
//import 'package:qrreaderapp/src/providers/db_provider.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class MapasPage extends StatelessWidget {
  //usamos la misma intancia de bloc
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    //return FutureBuilder<List<ScanModel>>(
    //stremaBuilder va a redibujar cada ves q haya cmabios en el flujo ned inf del Stream, se borra y obtenemos los cans q nos regresa lña lista vacia
    //cuando la lista vacia llega al Stream redibuja la inf,
    //cuando llega la lista
    return StreamBuilder<List<ScanModel>>(
      //future: DBProvider.db.getTodosScans(),
      //uusamos la misma intancia de bloc
      //necesitamos los stream de sncan

      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        //si o hay data
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final scans = snapshot.data;
        if (scans.length == 0) {
          return Center(
            child: Text('No hay informacion'),
          );
        }
        return ListView.builder(
            itemCount: scans.length,
            //posicion en i
            //dismisibble poder deslizar de izq a derecha un elemetno
            itemBuilder: (context, i) => Dismissible(
                  //crear llave unica, determinada para saber q item borrar
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                  ),
                  //el metodos q vaos a allmar cuando se borre todo, cuando se deslice
                  //llamamos al metodo de deleteScaner
                  // onDismissed: (direccion) =>
                  //   DBProvider.db.deleteScan(scans[i].id),

                  //va a lanzar la instancia de obtener bloc
                  onDismissed: (direccion) =>
                      scansBloc.borrarScans(scans[i].id),
                  child: ListTile(
                    leading: Icon(
                      Icons.cloud_queue,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(scans[i].valor),
                    //para ver el id
                    subtitle: Text('ID: ${scans[i].id}'),
                    //flechita para indicar q se puede abrir
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                    ),
                    onTap: () => utils.abrirScan(context, scans[i]),
                  ),
                ));
      },
    );
  }
}
