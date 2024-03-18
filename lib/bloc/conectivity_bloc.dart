import 'dart:convert';
import 'dart:ffi';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilasconelhueco/models/conectivity_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConectivityCubit extends Cubit<ConectivityStatus> {
  ConectivityCubit() : super(ConectivityStatus(connected: true));

  void saveConectivity(bool conectivity) async {
    ConectivityStatus conectivityStatus =
        ConectivityStatus(connected: conectivity);
    emit(conectivityStatus);
  }

  void getConectivityStatus() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    print("connectivity from cellfhone: $result");
    isInternetConnected(result);
  }

  void isInternetConnected(ConnectivityResult? result) {
    if (result == ConnectivityResult.none) {
      saveConectivity(false);
      return;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      saveConectivity(true);
      return;
    }
    //print("connectivity from jere: ${result}");
    saveConectivity(false);
  }
}
