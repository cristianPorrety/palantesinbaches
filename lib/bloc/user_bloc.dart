

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilasconelhueco/models/usuario_model.dart';
import 'package:pilasconelhueco/repository/databasemanager.dart';
import 'package:pilasconelhueco/shared/service_locator.dart';

class UsuarioCubit extends Cubit<UsuarioReport> {
  UsuarioCubit() : super(UsuarioReport());

  void getUserInfoIfThereis() async {
    if(await getit<DatabaseManipulator>().thereIsItems()) {
      var items = await getit<DatabaseManipulator>().getItems();
      emit(items);
    }
  }

  void createOrUpdateDataInfo(UsuarioReport usuario) async {
    await getit<DatabaseManipulator>().createUserInfo(usuario);
    getUserInfoIfThereis();
  }

}

