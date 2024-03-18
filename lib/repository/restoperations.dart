


import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pilasconelhueco/bloc/conectivity_bloc.dart';
import 'package:pilasconelhueco/models/ReportSaveModel.dart';

class RestOperations {

  final dio = Dio();
  static String backendHost = "https://jsonplaceholder.typicode.com";

  Future<List<ConfirmDataModel>> getReports() async{
    try {
      Response response = await dio.get('https://jsonplaceholder.typicode.com/').timeout(const Duration(seconds: 4));
      if(response.statusCode != 200) {
        return [ConfirmDataModel()..loaded = false];
      }
      List<Map<String, dynamic>> dataInRaw = response.data as List<Map<String, dynamic>>;
      List<ConfirmDataModel> confirmData = dataInRaw.map((e) => ConfirmDataModel.fromMap(e)).toList();
      return confirmData;
    } on TimeoutException catch (_) {
      return [ConfirmDataModel()..loaded = false];
    } on Exception catch(ex) {
      return [ConfirmDataModel()..loaded = false];
    }
  }

  Future<bool> postReport(ConfirmDataModel dataModel) async{
    print("on perform post");
    try {Response response = await dio.post('https://jsonplaceholder.typicode.com/', data: dataModel.toMap()).timeout(const Duration(seconds: 4));
    print("code obtained in post: ${response.statusCode}");
    if(response.statusCode != 200) {
      return false;
    }
    return true;
    } on TimeoutException catch (_) {
      return false;
    } on Exception catch(ex) {
      return false;
    }
  }

}
