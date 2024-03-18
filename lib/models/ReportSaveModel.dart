// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfirmDataModel {
  int? id;
  String? name;
  String? cellphone;
  String? email;
  String? address;
  String? motive;
  String? reportId;
  String? observation;
  String? reportDate;
  String? latitude;
  String? longitude;
  String? deviceId;
  String? deviceFamily;
  String? currentReportLatitude;
  String? currentReportLongitude;
  bool? loaded;
  int? onServer;
  List<File>? evidences;

  ConfirmDataModel();


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'cellphone': cellphone,
      'email': email,
      'address': address,
      'motive': motive,
      'observation': observation,
      'reportDate': reportDate,
      'latitude': "latitude",
      'longitude': "longitude",
      "reportId": reportId,
      'deviceId': deviceId,
      'deviceFamily': deviceFamily,
      'currentReportLatitude': currentReportLatitude,
      'currentReportLongitude': currentReportLongitude,
    };
  }

  factory ConfirmDataModel.fromMap(Map<String, dynamic> map) {
    final confirmData = ConfirmDataModel();
    confirmData.id = map['id'];
    confirmData.name = map['reported_by'];
    confirmData.cellphone = map['cellphone'];
    confirmData.email = map['email'];
    confirmData.address = map['address'];
    confirmData.motive = map['motive'];
    confirmData.observation = map['observation'];
    confirmData.reportId = map["report_id"];
    confirmData.reportDate = map['report_date'];
    confirmData.latitude = map['latitude'];
    confirmData.longitude = map['longitude'];
    confirmData.loaded = true;
    confirmData.deviceId = map['device_id'];
    confirmData.deviceFamily = map['device_family'];
    confirmData.currentReportLatitude = map['current_report_latitude'];
    confirmData.currentReportLongitude = map['current_report_longitude'];
    return confirmData;
  }

  String toJson() => json.encode(toMap());

  factory ConfirmDataModel.fromJson(String source) => ConfirmDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ConfirmDataModel(id: $id, name: $name, cellphone: $cellphone, email: $email, address: $address, motive: $motive, observation: $observation, reportDate: $reportDate, latitude: $latitude, longitude: $longitude, deviceId: $deviceId, deviceFamily: $deviceFamily, currentReportLatitude: $currentReportLatitude, currentReportLongitude: $currentReportLongitude, evidences: $evidences)';
  }

  @override
  bool operator ==(covariant ConfirmDataModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.cellphone == cellphone &&
      other.email == email &&
      other.address == address &&
      other.motive == motive &&
      other.observation == observation &&
      other.reportDate == reportDate &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.deviceId == deviceId &&
      other.deviceFamily == deviceFamily &&
      other.currentReportLatitude == currentReportLatitude &&
      other.currentReportLongitude == currentReportLongitude &&
      listEquals(other.evidences, evidences);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      cellphone.hashCode ^
      email.hashCode ^
      address.hashCode ^
      motive.hashCode ^
      observation.hashCode ^
      reportDate.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      deviceId.hashCode ^
      deviceFamily.hashCode ^
      currentReportLatitude.hashCode ^
      currentReportLongitude.hashCode ^
      evidences.hashCode;
  }

  
}
