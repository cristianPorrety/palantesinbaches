


import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pilasconelhueco/bloc/conectivity_bloc.dart';
import 'package:pilasconelhueco/models/ReportSaveModel.dart';

class RestOperations {

  final dio = Dio();
  static String backendHost = "https://lgl6n2vy9e.execute-api.us-east-1.amazonaws.com/prod";

  Future<List<ConfirmDataModel>> getReports(Map<String, String?> deviceId) async{
    try {
      Response response = await dio.get('$backendHost/reports', data: deviceId).timeout(const Duration(seconds: 4));
      print("code obtained in post: ${response.statusCode}");
      print("code obtained in post: ${response.data}");
      if(response.statusCode != 200) {
        return [ConfirmDataModel()..loaded = false];
      }
      List<Map<String, dynamic>> dataInRaw = response.data as List<Map<String, dynamic>>;
      print(dataInRaw);
      List<ConfirmDataModel> confirmData = dataInRaw.map((e) => ConfirmDataModel.fromMap(e)).toList();
      print(confirmData);
      return confirmData;
    } on TimeoutException catch (_) {
      print(_);
      return [ConfirmDataModel()..loaded = false];
    } on Exception catch(ex) {
      print(ex);
      return [ConfirmDataModel()..loaded = false];
    }
  }

  Future<bool> postReport(ConfirmDataModel dataModel) async{

    print("data model to post: ${dataModel.toMap()}");
    print("endpoint: $backendHost/persist");

    try {Response response = await dio.post('$backendHost/persist', data: dataModel.toMap()).timeout(const Duration(seconds: 10));
    print("code obtained in post: ${response.statusCode}");
    if(response.statusCode != 200) {
      return false;
    }
    return true;
    } on TimeoutException catch (_) {
      print(_);
      return false;
    } on Exception catch(ex) {
      print(ex);
      return false;
    }
  }

}
