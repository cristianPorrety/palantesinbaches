

import 'package:get_it/get_it.dart';
import 'package:pilasconelhueco/bloc/conectivity_bloc.dart';
import 'package:pilasconelhueco/bloc/motive_bloc.dart';
import 'package:pilasconelhueco/bloc/user_bloc.dart';
import 'package:pilasconelhueco/repository/databasemanager.dart';
import 'package:pilasconelhueco/repository/dataservice.dart';
import 'package:pilasconelhueco/repository/restoperations.dart';

GetIt getit = GetIt.asNewInstance();


void registerSingletons() {
  getit.registerSingleton(UsuarioCubit());
  getit.registerSingleton(ConectivityCubit()..getConectivityStatus());
  getit.registerSingleton(DatabaseManipulator()..initializeDB().then((value) => getit<UsuarioCubit>().getUserInfoIfThereis()));
  getit.registerSingleton(RestOperations());
  getit.registerSingleton(DataService()..getParametry());
  getit.registerSingleton(MotivesCubit());
}

