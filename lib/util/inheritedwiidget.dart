

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pilasconelhueco/models/ReportSaveModel.dart';

class ThreeScreensInheritedWidget extends InheritedWidget {
  Function(int) deleteFile;
  Function(File) addFile;
  Function(List<File>) addMultipleFiles;
  List<File> selectedFiles;
  Function(ConfirmDataModel) setConfirmDataModel;
  ConfirmDataModel? confirmDataModel;

  ThreeScreensInheritedWidget({required super.child, required this.deleteFile, required this.selectedFiles, required this.addFile, required this.addMultipleFiles, required this.setConfirmDataModel, this.confirmDataModel});
  

  static ThreeScreensInheritedWidget of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ThreeScreensInheritedWidget>()!;
  }



  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
  
}