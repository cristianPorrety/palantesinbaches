import 'package:flutter/foundation.dart';
import 'package:pilasconelhueco/bloc/conectivity_bloc.dart';
import 'package:pilasconelhueco/bloc/motive_bloc.dart';
import 'package:pilasconelhueco/models/ReportSaveModel.dart';
import 'package:pilasconelhueco/models/motive_model.dart';
import 'package:pilasconelhueco/repository/databasemanager.dart';
import 'package:pilasconelhueco/repository/restoperations.dart';
import 'package:pilasconelhueco/shared/service_locator.dart';
import 'package:pilasconelhueco/util/device_info.dart';

class DataService {
  Future<List<ConfirmDataModel>> getReports() async {
    var deviceId = await DeviceInfoManager.getDeviceId();
    var deviceIdModel = {"deviceId": deviceId};
    print("device id: $deviceIdModel");
    if (!getit<ConectivityCubit>().state.connected!) {
      var reportsLocal = await getit<DatabaseManipulator>().getReports();
      print("reports obtained: $reportsLocal");
      reportsLocal.sort(
        (a, b) {
          final aDateTime = DateTime.parse(a.reportDate!);
          final bDateTime = DateTime.parse(b.reportDate!);
          return aDateTime.compareTo(bDateTime);
        },
      );

      return reportsLocal.reversed
          .toList()
          .map((e) =>
              e.copyOf(reportId: e.onServer == 0 ? "pendiente" : e.reportId))
          .toList();
    }

    var reports = await getit<RestOperations>().getReports(deviceIdModel);
    print("reports obtained: $reports");
    if (reports.isNotEmpty && !reports[0].loaded!) {
      var reportsLocal = await getit<DatabaseManipulator>().getReports();
      reportsLocal.sort(
        (a, b) {
          final aDateTime = DateTime.parse(a.reportDate!);
          final bDateTime = DateTime.parse(b.reportDate!);
          return aDateTime.compareTo(bDateTime);
        },
      );
      return reportsLocal.reversed
          .toList()
          .map((e) =>
              e.copyOf(reportId: e.onServer == 0 ? "pendiente" : e.reportId))
          .toList();
    }

    await saveReportsFromRemote(List.of(reports));

    var reportsLocal = await getit<DatabaseManipulator>().getReports();
    reportsLocal.sort(
      (a, b) {
        final aDateTime = DateTime.parse(a.reportDate!);
        final bDateTime = DateTime.parse(b.reportDate!);
        return aDateTime.compareTo(bDateTime);
      },
    );
    return reportsLocal.reversed
        .toList()
        .map((e) =>
            e.copyOf(reportId: e.onServer == 0 ? "pendiente" : e.reportId))
        .toList();
  }

  Future<void> getParametry() async {
    var parametry = await getit<RestOperations>().getParametry();
    print("reports obtained: $parametry");
    if (parametry.isNotEmpty && parametry[0].code! == "ERROR") {
      return;
    }
    getit<MotivesCubit>().setMotiveCubit(parametry);
  }

  Future<void> saveReportsFromRemote(List<ConfirmDataModel> reports) async {
    for (var element in reports) {
      if (!await getit<DatabaseManipulator>()
          .thereAreReport(element.reportId!)) {
        getit<DatabaseManipulator>().createReport(element..onServer = 1);
      }
    }
  }

  Future<String> postReport(ConfirmDataModel dataModel) async {
    if (!getit<ConectivityCubit>().state.connected!) {
      print("no está conectado");
      getit<DatabaseManipulator>().createReport(dataModel..onServer = 0);
      return "SAVED_LOCALLY";
    }
    print("esta conectado");
    String saveReportFromRest =
        await getit<RestOperations>().postReport(dataModel);
    if (saveReportFromRest == "LOCATION_REPORT_NOT_VALID") {
      return saveReportFromRest;
    }
    if (saveReportFromRest != "SUCCESS") {
      print("no se pudo enviar");
      getit<DatabaseManipulator>().createReport(dataModel..onServer = 0);
      return "SAVED_LOCALLY";
    }

    if (await getit<DatabaseManipulator>().thereIsReports()) {
      print("hay datos persistidos");
      sendReportNotSent();
    }
    print("se envio todo correcto");
    getit<DatabaseManipulator>().createReport(dataModel..onServer = 1);
    return saveReportFromRest;
  }

  Future<void> sendReportNotSent() async {
    var items = await getit<DatabaseManipulator>().getReportsNotSent();
    for (var element in items) {
      getit<DatabaseManipulator>().turnOfOnServer(true);
      print("report sent from isolate");
      getit<RestOperations>().postReport(element);
    }
  }
}

void sendReportNotSent(int _) async {
  var items = await getit<DatabaseManipulator>().getReportsNotSent();
  for (var element in items) {
    getit<DatabaseManipulator>().turnOfOnServer(true);
    print("report sent from isolate");
    getit<RestOperations>().postReport(element);
  }
}
