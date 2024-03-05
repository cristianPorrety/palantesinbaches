import 'package:flutter/material.dart';
import 'package:pilasconelhueco/home/homepage.dart';
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
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 30.0,
          columns: [
            DataColumn(label: Text('Mis Reportes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Fecha y Hora', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Info', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Estado', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
          ],
          rows: reports.map((report) => DataRow(
            cells: [
              DataCell(
                Text(
                  report.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  report!.dateTime,
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
                              Text("Reporte número: ${report.name} ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                              Divider(),
                              Text("En proceso",style: TextStyle(fontSize: 14,)),
                            ],
                          ),
                          content: Container(
                            width: 400,
                            height: 200,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ubicación:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                Text("Carrera 9, Calle 15, Avenida Libertador", style: TextStyle(fontSize: 15, )),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Motivo:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                    SizedBox(width: 90),
                                    Text("Fecha:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                    SizedBox(height: 10),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Envejecimiento"),
                                    SizedBox(width: 40),
                                    Text("26-10-2023"),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text("Observación:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsPalet.primaryColor)),
                                Text("Hueco en la vía que ha provocado varios accidentes."),
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
              DataCell(
                Text(
                  report!.estado,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )).toList(),
        ),
      ),
    );
  }
}
