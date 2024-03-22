import 'package:flutter/material.dart';
import 'package:pilasconelhueco/bloc/user_bloc.dart';
import 'package:pilasconelhueco/screens/DataScreen.dart';
import 'package:pilasconelhueco/screens/otherApps.dart';
import 'package:pilasconelhueco/screens/reports.dart';
import 'package:pilasconelhueco/shared/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/Report.dart';
import '../screens/contact.dart';
import '../shared/styles.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String selectedItem = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      child: SingleChildScrollView( // Envuelve todo el contenido con SingleChildScrollView
        child: Container(
          width: screenWidth * 0.7,
          padding: EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, color: ColorsPalet.primaryColor, size: 30,),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Image.asset(
                            'assets/img/tittle_drawer.png',
                            width: 300.0,
                            height: 40.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage(
                      'assets/img/profile.png',
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Text(
                    '¡BIENVENIDO!',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    getit<UsuarioCubit>().state.nombre ?? "Ciudadano",
                    style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: ColorsPalet.primaryColor,),
                  ),
                ),
                SizedBox(height: 40.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSelectionItem('MIS DATOS'),
                    SizedBox(height: 14,),
                    _buildSelectionItem('MIS REPORTES'),
                    SizedBox(height: 14,),
                    _buildSelectionItem('LINEA DE ATENCIÓN'),
                    SizedBox(height: 14,),
                    _buildSelectionItem('MÁS APLICACIONES'),
                    SizedBox(height: 90.0),
                    Center(
                      child: Image.asset(
                        'assets/img/logo_drawer.png',
                        width: 230.0,
                        height: 100.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        SizedBox(height: 20.0),
                        Center(
                          child: Container(
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      // Redireccionar a Instagram
                                      launch('https://www.instagram.com/santamartadtch/');
                                    },
                                    child: Image.asset(
                                      'assets/img/instagram.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Redireccionar a Facebook
                                      launch('https://www.facebook.com/SantaMartaDTCH?mibextid=ZbWKwL');
                                    },
                                    child: Image.asset(
                                      'assets/img/facebook.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Redireccionar a Twitter
                                      launch('https://twitter.com/SantaMartaDTCH');
                                    },
                                    child: Image.asset(
                                      'assets/img/twitter.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedItem = text;
          });
          if (text == 'MÁS APLICACIONES') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OtherAppsPage()),
            );
          }
          if (text == 'LINEA DE ATENCIÓN') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Contacts()),
            );
          }
          if (text == 'MIS REPORTES') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Reports(reports: reports)),
            );
          }
          if (text == 'MIS DATOS') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DataScreen()),
            );
          }
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

}
