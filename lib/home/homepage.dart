


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pilasconelhueco/bloc/conectivity_bloc.dart';
import 'package:pilasconelhueco/home/drawer.dart';
import 'package:pilasconelhueco/models/Report.dart';
import 'package:pilasconelhueco/screens/DataScreen.dart';
import 'package:pilasconelhueco/screens/otherApps.dart';
import 'package:pilasconelhueco/shared/labels.dart';
import 'package:pilasconelhueco/shared/service_locator.dart';
import 'package:pilasconelhueco/shared/styles.dart';

import '../screens/contact.dart';
import '../screens/huecosbaches.dart';
import '../screens/reports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
  
}


class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("on net change test: $result");
      getit<ConectivityCubit>().isInternetConnected(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                              color: ColorsPalet.primaryColor,
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                            ),
                height: 230,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 106, left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Icon(Icons.menu, size: 30, color: ColorsPalet.backgroundColor,),
                      ),
                      SizedBox(
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            SizedBox(
                              width: 110,
                              height: 21,
                              child: Row(
                                children: [
                                  Text(SplashScreenText.mainTextFirst, style: TextStyle(color: ColorsPalet.backgroundColor, fontWeight: FontWeight.bold, fontSize: 20,)),
                                  Text(SplashScreenText.mainBlueText, style: TextStyle(color: ColorsPalet.secondaryColor, fontWeight: FontWeight.bold, fontSize: 20),),
                                ],
                              ),
                            ),
                            Text(SplashScreenText.mainTextSecond, style: TextStyle(color: ColorsPalet.backgroundColor, fontWeight: FontWeight.bold, fontSize: 30,),),
                          ],
                        ),
                      ),
                      SizedBox(width: 20,)
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: ColorsPalet.backgroundColor),
              ),
            ],
          ),
          const SafeArea(
            child: Center(
               child: MenuFragment(),
            ),
          ),
        ],
      ),
    );
  }
  
}




class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeTopBarState createState() {
    return _HomeTopBarState();
  }

}


class _HomeTopBarState extends State {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
  
}


class MenuFragment extends StatelessWidget {
  const MenuFragment({super.key});

  
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 70),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          color: ColorsPalet.backgroundColor
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: Text(MainPageText.title, style: const TextStyle(fontWeight: FontWeight.w700),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ReportPotholesScreen()),
                        );
                      },
                    child: menuItem(ImagesPath.carreteraImg, MainPageText.hoolTitle, MainPageText.hoolDesc)
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => DataScreen()),
                        );
                      },
                      
                    child: menuItem(ImagesPath.mydataImg, MainPageText.myDataTitle, MainPageText.myDataDesc)
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Reports(reports: reports)),
                      );
                    },
                    child: menuItem(ImagesPath.reportsImg, MainPageText.myReportsTitle, MainPageText.myReportsDesc),
                  ), GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Contacts()),
                      );
                    },
                    child: menuItem(ImagesPath.atentionlineImg, MainPageText.atentionLineTitle, MainPageText.atentionLineDesc),
                  ),
                ],
              ),
                      
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OtherAppsPage()),
                  );
                },
                child: menuItem(ImagesPath.anotherAppImg, MainPageText.otherAppsTitle, MainPageText.otherAppsDesc),
              ),
              Column(
                children: [
                  Text(
                    AlcaldiaSantaMartaText.mainText,
                    style: TextStyle(color: ColorsPalet.primaryColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AlcaldiaSantaMartaText.secondText,
                    style: TextStyle(color: ColorsPalet.primaryColor, fontSize: 11.1),
                  ),
                ],
              ),
            ],
                      ),
          ),
        ),
      ),
    );
  }
}


Widget menuItem(String img, String text, String desc) {

  return SizedBox(
    width: 130,
    height: 165,
    child: Column(
      children: [
        SizedBox(width: 70, height: 70,child: Image.asset(img),),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
        Expanded(
          child: Container(padding: const EdgeInsets.only(top: 5), width: 100, child: Text(desc, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center,))
        )
      ],
    ),
  );

}

