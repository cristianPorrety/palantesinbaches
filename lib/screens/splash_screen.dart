import 'package:flutter/material.dart';

import 'huecosbaches.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReportPotholesScreen()), // Reemplaza 'YourNextScreen()' con la clase de tu siguiente pantalla
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF2C4C71),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
            Column(
              children: [
                Image.asset('assets/img/Capa_1.png'),
                SizedBox(height: 10),
                Image.asset('assets/img/Group 6.png'),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/img/img_splash_Screen.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
