

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


  Future<void> initializeDB() async {
    String path = await getDatabasesPath();
    
    db = await openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
         await database.execute( 
           'CREATE TABLE confirm_data('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'reported_by TEXT, '
        'cellphone TEXT, '
        'email TEXT, '
        'address TEXT, '
        'motive TEXT, '
        'observation TEXT, '
        'report_date TEXT, '
        'latitude TEXT, '
        'longitude TEXT, '
        'onServer INTEGER, '
        'device_id TEXT, '
        'report_id TEXT, '
        'device_family TEXT, '
        'current_report_latitude TEXT, '
        'current_report_longitude TEXT)',
      );
      await database.execute(
        'CREATE TABLE usuario_report('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'nombre TEXT, '
        'celular TEXT, '
        'correoElectronico TEXT, '
        'genero TEXT, '
        'profilePic TEXT, '
        'fechaNacimiento TEXT, '
        'edad INTEGER)',
      );
      await database.execute(
        'CREATE TABLE file_report('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'file_path TEXT, '
        'device_id TEXT, '
        'report_id TEXT)',
      );
     },
     version: 1,
    );
  }


  Future<List<Map<String, dynamic>>> getReportFiles() async {
    final List<Map<String, Object?>> queryResult =
    await db.query('file_report');
    print('reports files saved locally: $queryResult');
    return queryResult;
  }

  Future<void> deleteReportFile(String reportId) async {
    await db.delete("file_report", where: "report_id = ?", whereArgs: [reportId]);
  }


  Future<void> createFileInfo(String filePath, String reportId, String deviceId) async {
    print("file path: $filePath, report id: $reportId");
    await db.insert(
        'file_report', {"file_path": filePath, "report_id": reportId, "device_id": deviceId},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<void> createUserInfo(UsuarioReport user) async {
    if(await thereIsItems()) {
      _updateUser(user);
    } else {
      user.id = 1;
      print(user.toMap());
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
    return queryResult.isNotEmpty;
  }

  void _updateUser(UsuarioReport user) async {
    UsuarioReport currentUsuarioReportId = await getItems();
    print(currentUsuarioReportId.toString());
    user.id = currentUsuarioReportId.id;
    await db.update(
        "usuario_report",
        user.toMap(),
        where: 'id = ?',
        whereArgs: [currentUsuarioReportId.id]);
  }


  Future<void> createReport(ConfirmDataModel user) async {
    print("report to be saved : ${user.toMap()}");
    await db.insert(
      'confirm_data', user.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace);   
  }

  Future<void> turnOfOnServer(bool user) async {
    await db.update(
      'confirm_data', {'onServer': (user) ? 1 : 0}, 
      conflictAlgorithm: ConflictAlgorithm.replace);   
  }

  Future<List<ConfirmDataModel>> getReports() async {
    final List<Map<String, Object?>> queryResult = 
      await db.query('confirm_data');
    return queryResult.map((e) => ConfirmDataModel.fromMap(e)).toList();
  }

  Future<List<ConfirmDataModel>> getReportsNotSent() async {
    final List<Map<String, Object?>> queryResult = 
      await db.query('confirm_data', where: 'onServer = 0');
    return queryResult.map((e) => ConfirmDataModel.fromMap(e)).toList();
  }

  Future<bool> thereIsReports() async{
    final List<Map<String, Object?>> queryResult = 
      await db.query('confirm_data', where: 'onServer = 0');
    print("there is reports: $queryResult");
    return queryResult.isNotEmpty;
  }

  Future<bool> thereAreReport(String reportId) async{
    final List<Map<String, Object?>> queryResult =
    await db.query('confirm_data', where: 'report_id = ?', whereArgs: [reportId]);
    print("there is reports: $queryResult");
    return queryResult.isNotEmpty;
  }

}

