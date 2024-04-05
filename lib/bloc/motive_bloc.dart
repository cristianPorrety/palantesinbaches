import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilasconelhueco/models/motive_model.dart';

class MotivesCubit extends Cubit<List<MotiveModel>> {
  MotivesCubit()
      : super([
          MotiveModel(name: "INSTALACION DE TUBERIAS"),
          MotiveModel(name: "ENVEJECIMIENTO"),
          MotiveModel(name: "HUNDIMIENTO O SOCAVACION"),
          MotiveModel(name: "TRÁFICO PESADO"),
          MotiveModel(name: "MALA CALIDAD DE LOS MATERIALES"),
          MotiveModel(name: "OTROS"),
        ]);

  void setMotiveCubit(List<MotiveModel> nameModel) {
    emit(nameModel);
  }

}
