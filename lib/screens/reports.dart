import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilasconelhueco/home/homepage.dart';
import 'package:pilasconelhueco/repository/dataservice.dart';
import 'package:pilasconelhueco/repository/restoperations.dart';
import 'package:pilasconelhueco/shared/service_locator.dart';
import 'package:pilasconelhueco/shared/styles.dart';
import '../models/Report.dart';

class Reports extends StatelessWidget {
  final List<Report> reports;

  Reports({required this.reports});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: ColorsPalet.primaryColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          centerTitle: true,
          title: Text(
            'Mis Reportes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder(
            future: getit<DataService>().getReports(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 180),
                  child: Center(
                    child: SizedBox(
                        child: CircularProgressIndicator()
                    ),
                  ),
                );
              }
              return DataTable(
            columnSpacing: 30.0,
            columns: [
              DataColumn(label: Text('Id Reporte', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('Reportado por', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('Fecha y Hora', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('Info', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
            ],
            rows: snapshot.data!.map((report) => DataRow(
              cells: [
                DataCell(
                  Text(
                    report.reportId!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(
                  Text(
                    report.name!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(
                  Text(
                    report.reportDate!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Text("Reporte: ${report.reportId} ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                Divider(),
                              ],
                            ),
                            content: Container(
                              width: 400,
                              height: 300,
                              padding: EdgeInsets.all(16),
                              child: ListView(
                                children: [
                                  Text("Ubicación:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                  Text(report.address!, style: TextStyle(fontSize: 15, )),
                                  SizedBox(height: 10),
                                  Text("Motivo:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                  Text(report.motive!),
                                  SizedBox(height: 10),
                                  Text("Fecha:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                  Text(report.reportDate!.substring(0, 19)),
                                  SizedBox(height: 10),
                                  Text("Observación:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                  Text(report.observation!),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Cerrar",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.info, color: ColorsPalet.primaryColor),
                  ),
                ),
              ],
            )).toList(),
          );
            },
          ),
        )
      ),
    );
  }
}
