


import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pilasconelhueco/home/homepage.dart';

import '../screens/huecosbaches.dart';

class ToastManager {

  static void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context); 

    scaffold.showSnackBar(SnackBar(
      content: Text(message), 
      action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ));
  }

  static void showToastOnTop(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ));
  }


}
class ToastManager2 {
  static void showPersistentToast(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 100),
        action: SnackBarAction(
          label: 'Configuración',
          onPressed: () async {
            // Abre la configuración de la aplicación en el dispositivo
            await openAppSettings();
            ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Oculta el Snackbar actual
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 1),
      ),
    );
  }
}
