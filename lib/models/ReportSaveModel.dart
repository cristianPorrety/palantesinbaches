import 'dart:io';

import 'package:flutter/material.dart';

class ConfirmDataModel {
  String? name;
  String? cellphone;
  String? email;
  String? address;
  String? motive;
  String? reportDate;
  List<File>? evidences;

  ConfirmDataModel({
    required this.name,
    required this.cellphone,
    required this.email,
    required this.address,
    required this.motive,
    required this.reportDate,
    required this.evidences,
  });

}
