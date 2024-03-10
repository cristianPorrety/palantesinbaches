

import 'package:pilasconelhueco/models/ReportSaveModel.dart';
import 'package:pilasconelhueco/models/usuario_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManipulator {
  static DatabaseManipulator? _instance;
  late Database db;


  static DatabaseManipulator getInstance() {
    if(_instance == null) {
      _instance = DatabaseManipulator();
      _instance!.initializeDB();
    }
    return _instance!;
  }


  void initializeDB() async {
    String path = await getDatabasesPath();
    
    db = await openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
         await database.execute( 
           'CREATE TABLE confirm_data('
        'id INTEGER PRIMARY KEY, '
        'name TEXT, '
        'cellphone TEXT, '
        'email TEXT, '
        'address TEXT, '
        'motive TEXT, '
        'observation TEXT, '
        'reportDate TEXT, '
        'latLng TEXT, '
        'deviceId TEXT, '
        'deviceFamily TEXT, '
        'currentReportLocation TEXT)',
      );
      await database.execute(
        'CREATE TABLE usuario_report('
        'id INTEGER PRIMARY KEY, '
        'nombre TEXT, '
        'celular TEXT, '
        'correoElectronico TEXT, '
        'genero TEXT, '
        'edad INTEGER)',
      );
     },
     version: 1,
    );
  }

  Future<void> createUserInfo(UsuarioReport user) async {
    if(await thereIsItems()) {
      _updateUser(user);
    } else {
      await db.insert(
      'usuario_report', user.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace);   
    }
  }

  Future<UsuarioReport> getItems() async {
    final List<Map<String, Object?>> queryResult = 
      await db.query('usuario_report');
    return UsuarioReport.fromMap(queryResult.first);
  }

  Future<bool> thereIsItems() async {
    final List<Map<String, Object?>> queryResult = 
      await db.query('usuario_report');
    return queryResult.isEmpty;
  }

  void _updateUser(UsuarioReport user) async {
    UsuarioReport currentUsuarioReportId = await getItems();
    await db.update(
        "usuario_report",
        user.toMap(),
        where: 'id = ?',
        whereArgs: [currentUsuarioReportId.id]);
  }


  Future<void> createReport(ConfirmDataModel user) async {
    await db.insert(
      'confirm_data', user.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace);   
  }

  Future<List<ConfirmDataModel>> getReports() async {
    final List<Map<String, Object?>> queryResult = 
      await db.query('confirm_data');
    return queryResult.map((e) => ConfirmDataModel.fromMap(e)).toList();
  }

}

