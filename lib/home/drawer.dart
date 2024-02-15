import 'package:flutter/material.dart';
import '../shared/styles.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
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
                'CARLOS GUTIERREZ',
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
                SizedBox(height: 130.0),
                Center(
                  child: Image.asset(
                    'assets/img/logo_drawer.png',
                    width: 240.0,
                    height: 110.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Icon(
                        Icons.facebook,
                        size: 30,
                        color: Colors.blue,
                      ),
                      Icon(
                        Icons.facebook,
                        size: 30,
                        color: Colors.pink,
                      ),
                      Icon(
                        Icons.facebook,
                        size: 30,
                        color: Colors.black,
                      ),
                  ],
                  ),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
