import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfirmDataModel {
  String? name;
  String? cellphone;
  String? email;
  String? address;
  String? motive;
  String? observation;
  String? reportDate;
  LatLng? latLng;
  String? deviceId;
  String? deviceFamily;
  LatLng? currentReportLocation;
  List<File>? evidences;

  ConfirmDataModel();
}
