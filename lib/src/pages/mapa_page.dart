import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:latlong/latlong.dart';

class MapaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //para q se ,uestre las coordenadas
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Coodernadas QR'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.my_location), onPressed: () {})
          ],
        ),
        body: _crearFlutterMap(scan)

        /* Center(
        //valor de geo
        child: Text(scan.valor),
      ),*/
        );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      options: MapOptions(
          //metodo q ayude a retornar l alatitud y longitud
          center: scan.getLatLng(),
          zoom: 10),
      //cpas de inf q queremos poner
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  /*_crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.tiles.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiYmVydG8xOCIsImEiOiJja2ZxOHI4eDAyZW45MnVuenplN3pybWdjIn0.bAul9alK61_FgrRD-MDhQw',
          'id': 'mapbox.dark'
          //'mapbox.dark'
          // 5 de mapas q tenemos streets, deark, light, outdoors, satellite
        });
  }*/
  _crearMapa() {
    return TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiYmVydG8xOCIsImEiOiJja2ZxOHI4eDAyZW45MnVuenplN3pybWdjIn0.bAul9alK61_FgrRD-MDhQw',
          'id': 'mapbox/streets-v11'
        });
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          //punto donde aparezca el margador
          point: scan.getLatLng(),
          //instruccion para q se dibuje el marcador
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 45.0,
                  color: Theme.of(context).primaryColor,
                ),
              ))
    ]);
  }
}
