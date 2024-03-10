

import 'package:get_it/get_it.dart';
import 'package:pilasconelhueco/bloc/conectivity_bloc.dart';

GetIt getit = GetIt.asNewInstance();


void registerSingletons() {
  getit.registerSingleton(ConectivityCubit()..getConectivityStatus());
}

