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
          columnSpacing: 37.0,
          columns: [
            DataColumn(label: Text('Mis Reportes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Fecha y Hora', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Info', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Estado', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
          ],
          rows: reports.map((report) => DataRow(
            cells: [
              DataCell(Text(report.name)),
              DataCell(Text(report!.dateTime)),
              DataCell(Icon(Icons.info, color: ColorsPalet.primaryColor)),
              DataCell(Text(report!.estado )),
            ],
          )).toList(),
        ),
      ),
    );
  }
}

