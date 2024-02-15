import 'package:flutter/material.dart';
import 'package:pilasconelhueco/home/homepage.dart';
import 'package:pilasconelhueco/shared/styles.dart';
import '../shared/labels.dart';

class OtherAppsPage extends StatelessWidget {
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
            OtherAppsText.title,
            style: TextStyle(color: ColorsPalet.backgroundColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image.asset('assets/img/icon_app.png'),
            ),
            SizedBox(width: 10.0),

            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    'MUEVÉTE',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.0),
                  // Texto
                  Text(
                    'La plataforma que te permite la gestión de medio del transporte.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5.0),
            ElevatedButton(
              onPressed: () {
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(ColorsPalet.primaryColor),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              child: Text('Instalar'),
            ),
          ],
        ),
      ),
    );
  }
}

