


import 'package:flutter/material.dart';

class ToastManager {

  static void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context); 

    scaffold.showSnackBar(SnackBar(
      content: Text(message), 
      action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ));
  }

}