import 'package:flutter/material.dart';
import 'package:pilasconelhueco/home/homepage.dart';
import 'package:pilasconelhueco/shared/styles.dart';
import '../shared/labels.dart';

class DataScreen extends StatelessWidget {
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
            DataText.title,
            style: TextStyle(color: ColorsPalet.backgroundColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Image.asset('assets/img/profile.png'),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(Icons.camera_alt, color: Colors.grey, size: 30,),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Carlos Gutiérrez'),
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              title: Text('Celular', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('+57 3044495884'),
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              title: Text('Correo electrónico', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('carlosgutierrez123@gmail.com'),
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              title: Text('Genero', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Masculino'),
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              title: Text('Edad', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('40-50'),
              trailing: Icon(Icons.navigate_next),

            ),
        Padding(
          padding: EdgeInsets.only(top: 70.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
              },
              child: Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(ColorsPalet.primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
            ),
          ),
        ),
    ],
    ),
      ),
    );
  }
}
