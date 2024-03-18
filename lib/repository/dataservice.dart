

import 'package:flutter/foundation.dart';
import 'package:pilasconelhueco/bloc/conectivity_bloc.dart';
import 'package:pilasconelhueco/models/ReportSaveModel.dart';
import 'package:pilasconelhueco/repository/databasemanager.dart';
import 'package:pilasconelhueco/repository/restoperations.dart';
import 'package:pilasconelhueco/shared/service_locator.dart';

class DataService {

  Future<List<ConfirmDataModel>> getReports() async {
    if(!getit<ConectivityCubit>().state.connected!){
      return getit<DatabaseManipulator>().getReports();
    }

    var reports = await getit<RestOperations>().getReports();
    if(reports.isNotEmpty && !reports[0].loaded!) {
      return getit<DatabaseManipulator>().getReports();
    }

    return getit<RestOperations>().getReports();

  }

  Future<bool> postReport(ConfirmDataModel dataModel) async {
    if(!getit<ConectivityCubit>().state.connected!) {
      print("no está conectado");
      getit<DatabaseManipulator>().createReport(dataModel);
      return true;
    }
    print("esta conectado");
    bool saveReportFromRest = await getit<RestOperations>().postReport(dataModel);
    if(!saveReportFromRest) {
      print("no se pudo enviar");
      getit<DatabaseManipulator>().createReport(dataModel);
      return true;
    }

    if(await getit<DatabaseManipulator>().thereIsReports()) {
      print("hay datos persistidos");
      await compute(sendReportNotSent, 0);
    }
    print("se envio todo correcto");
    return saveReportFromRest;
  }

}


void sendReportNotSent(int _) async {
  var items = await getit<DatabaseManipulator>().getReportsNotSent();
  for (var element in items) {
    await getit<DatabaseManipulator>().turnOfOnServer(true);
    await getit<RestOperations>().postReport(element);
  }
}


