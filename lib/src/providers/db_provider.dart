import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvider {
  //solo tener una estancia de manera global, sea 1 sola
  //instancia a la bdd
  static Database _database;
  //contructor privado, no se reinicialice
  static final DBProvider db = DBProvider._();

  DBProvider._();

//tener la inf privada
  Future<Database> get database async {
    if (_database != null) return _database;
    //caso contrario no exite
    _database = await initDB();

    return _database;
  }

//tiene q regesar una instancia _database
  initDB() async {
    //crear una intancia, donde se va a enocntrar el path la bdd si se reo
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //path completo d edonde se encuceuntra la bdd
    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(path,
        version: 1,
        //intancia de la bdd
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')');
    });
  }

//metodos para crear registros
  nuevoScanRaw(ScanModel nuevoScan) async {
    //verificar si tenemos listas
    //esperar a obtner la bdd
    final db = await database;

    final res = await db.rawInsert("INSERT Into Scans (id,tipo,valor) "
        "VALUES ( ${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}') ");
    return res;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    //json, tranfsorma le modelo y devuelve un mapa q es lo q se puede enviar en  el insert
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  //SELECT- obtener informacion
  Future<ScanModel> getScanId(int id) async {
    //verificar si piodemos escribir en la bdd
    final db = await database;
    //un argumento en el where (?)
    final res = await db.query('Scans', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  //traer todos los scan
  Future<List<ScanModel>> getTodosLosScans() async {
    final db = await database;
    final res = await db.query('Scans');
    //crea intancias de scanmodel
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  //get de todos los scan del tipo
  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  //Actualizar regitstros
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id=?', whereArgs: [nuevoScan.id]);
    return res;
  }

//Eliminar resgistros
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id=?', whereArgs: [id]);
    return res;
  }

  //Eliminar todos los registros
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}
