import 'package:flutter/material.dart';
import 'package:pilasconelhueco/home/homepage.dart';
import 'package:pilasconelhueco/repository/databasemanager.dart';
import 'package:pilasconelhueco/shared/service_locator.dart';

import '../onboarding/onboardingpage.dart';
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
      getit<DatabaseManipulator>().thereIsItems()
      .then((value) {
        if(value) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen(),));
        }
      });
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
