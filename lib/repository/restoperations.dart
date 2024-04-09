


import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pilasconelhueco/bloc/conectivity_bloc.dart';
import 'package:pilasconelhueco/models/ReportSaveModel.dart';
import 'package:pilasconelhueco/models/motive_model.dart';

class RestOperations {

  final dio = Dio();
  static String backendHost = "https://lgl6n2vy9e.execute-api.us-east-1.amazonaws.com/prod";

  Future<List<ConfirmDataModel>> getReports(Map<String, String?> deviceId) async{
    try {
      Response response = await dio.get('$backendHost/reports', data: deviceId).timeout(const Duration(seconds: 4));
      print("code obtained in post: ${response.statusCode}");
      //(response.data["data"] as List);
      print("code obtained in post: ${jsonDecode(response.data as String)}");
      if(response.statusCode != 200) {
        return [ConfirmDataModel()..loaded = false];
      }
      //print(dataInRaw);
      List<dynamic> jsonList = jsonDecode(response.data as String);
      List<Map<String, dynamic>> listOfMaps = jsonList.map((jsonObject) {
        return Map<String, dynamic>.from(jsonObject); // Convert each element into a Map<String, dynamic>
      }).toList();
      List<ConfirmDataModel> confirmData = (listOfMaps).map((e) => ConfirmDataModel.fromMap(e)).toList();
      print("server response data: $confirmData");
      return confirmData;
    } on TimeoutException catch (_) {
      print(_);
      return [ConfirmDataModel()..loaded = false];
    } on DioException catch (dx) {
      print(dx);
      return [ConfirmDataModel()..loaded = false];
    } on Exception catch(ex) {
      print(ex);
      return [ConfirmDataModel()..loaded = false];
    }
    return [ConfirmDataModel()..loaded = false];
  }

  Future<String> postReport(ConfirmDataModel dataModel) async{

    print("data model to post: ${dataModel.toMap()}");
    print("endpoint: $backendHost/persist");

    try {Response response = await dio.post('$backendHost/persist', data: dataModel.toMap()).timeout(const Duration(seconds: 10));
    print("code obtained in post: ${response.statusCode}");
    print("server response data: ${response.data}");
    Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(response.data));
    if(response.statusCode != 200) {
      return "ERROR";
    }
    return data["status"];
    } on TimeoutException catch (_) {
      print(_);
      return "ERROR";
    } on Exception catch(ex) {
      print(ex);
      return "";
    }
  }


  Future<List<MotiveModel>> getParametry() async{
    try {
      Response response = await dio.post('$backendHost/parametry').timeout(const Duration(seconds: 4));
      print("code obtained in post: ${response.statusCode}");
      //(response.data["data"] as List);
      print("code obtained in post: ${jsonDecode(response.data as String)}");
      if(response.statusCode != 200) {
        return [MotiveModel()..code = "ERROR"];
      }
      Map<String, dynamic> motiveData = jsonDecode(response.data as String);
      //print(dataInRaw);
      List<dynamic> jsonList = motiveData["data"]["motives"];
      List<Map<String, dynamic>> listOfMaps = jsonList.map((jsonObject) {
        return Map<String, dynamic>.from(jsonObject); // Convert each element into a Map<String, dynamic>
      }).toList();
      List<MotiveModel> confirmData = (listOfMaps).map((e) => MotiveModel.fromMap(e)).toList();
      print("server response data: $confirmData");
      return confirmData;
    } on TimeoutException catch (_) {
      print(_);
      return [MotiveModel()..code = "ERROR"];
    } on DioException catch (dx) {
      print(dx);
      return [MotiveModel()..code = "ERROR"];
    } on Exception catch(ex) {
      print(ex);
      return [MotiveModel()..code = "ERROR"];;
    }
  }


  Future<String> sendFiles(File file, String reportId, String deviceId) async{

    print("endpoint: $backendHost/report-media?report=$reportId&device=$deviceId");

    String fileName = file.path.split('/').last;
    Uint8List binary = await file.readAsBytes();
    //FormData formData = FormData.fromBytes(binaryData);
    String fileExtension = file.path.split(".").last;
    try {
      final response = 
        await dio.post("$backendHost/report-media", 
            data: Stream.fromIterable(binary.map((e) => [e])), 
            queryParameters: {"report": reportId, "ext": fileExtension, "device": deviceId},
            options: Options(contentType: "application/zip"));
      if(response.statusCode != 200) {
        return "ERROR";
      }
      return "SUCCESS";
    } on TimeoutException catch (_) {
      print("timeout error on post report: $_");
      return "ERROR";
    } on Exception catch(ex) {
      print("error error on post report: $ex");
      return "";
    }
  }

}
