import 'package:flutter/material.dart';
import 'package:pilasconelhueco/home/homepage.dart';
import 'package:pilasconelhueco/shared/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/labels.dart';

class Contacts extends StatelessWidget {
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
            ContactInfoTexts.title,
            style: TextStyle(color: ColorsPalet.backgroundColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/img/logo_Stm.png'),
            Divider(height:50,),
            SizedBox(height: 60,),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                children: <TextSpan>[
                  TextSpan(text: "${ContactInfoTexts.alcaldiaDistrital}\n", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "${ContactInfoTexts.nit}\n\n"),
                  TextSpan(text: "${ContactInfoTexts.horarioAtencion}\n\n", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "${ContactInfoTexts.horarioAtencionres}\n\n"),
                  TextSpan(text: "${ContactInfoTexts.lineaNacional}\n\n", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "${ContactInfoTexts.lineaNacionalres}\n\n"),
                  TextSpan(text: "${ContactInfoTexts.lineaFija}\n\n", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "${ContactInfoTexts.lineaFijares}\n\n"),
                  TextSpan(text: "${ContactInfoTexts.correo}\n\n", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "${ContactInfoTexts.correores}\n\n"),
                  TextSpan(text: "${ContactInfoTexts.politicas}\n\n"),
                  TextSpan(text: "${ContactInfoTexts.derechosReservados}"),
                ],
              ),
            ),
            SizedBox(height: 60,),
            Divider(height:50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Redireccionar a Instagram
                    launch('https://www.instagram.com/tu_usuario');
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
                    launch('https://www.facebook.com/mariajose.lopezavila.94');
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
                    launch('https://www.twitter.com/tu_usuario');
                  },
                  child: Image.asset(
                    'assets/img/twitter.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Contacts(),
  ));
}