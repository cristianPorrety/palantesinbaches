import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:pilasconelhueco/home/homepage.dart';
import 'package:pilasconelhueco/shared/styles.dart';
import '../shared/labels.dart';
import '../util/alerts.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController correoElectronicoController = TextEditingController();
  TextEditingController generoController = TextEditingController();
  DateTime? selectedDate; // Variable para almacenar la fecha seleccionada

  FocusNode nombreFocus = FocusNode();
  FocusNode celularFocus = FocusNode();
  FocusNode correoFocus = FocusNode();
  FocusNode generoFocus = FocusNode();
  FocusNode edadFocus = FocusNode();

  bool isEditing = false;
  String nombreErrorMessage = '';
  String celErrorMessage = '';
  String correoErrorMessage = '';
  String generoErrorMessage = '';
  String edadErrorMessage = '';
  TextEditingController edadController = TextEditingController();
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
              if (isEditing) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DataScreen()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
            },
          ),
          centerTitle: true,
          title: Text(
            DataText.title,
            style: TextStyle(
                color: ColorsPalet.backgroundColor,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit, size: 25, color: Colors.white),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            _buildListTile("Nombre", nombreController, nombreErrorMessage, nombreFocus),
            _buildListTile("Celular", celularController, celErrorMessage, celularFocus),
            _buildListTile("Correo electrónico", correoElectronicoController, correoErrorMessage, correoFocus),
            _buildListTile("Genero", generoController, generoErrorMessage, generoFocus),
            _buildDateSelectorTile("Edad", selectedDate),
            if (isEditing)
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                        });
                      },
                      child: Text('Cancelar',style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white, fontSize: 20),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_allErrorMessagesAreEmpty()) {
                          setState(() {
                            isEditing = false;
                          });
                        } else {
                          ToastManager.showToast(context, "Por favor, verifique que los datos ingresados sean correctos.");
                        }
                      },
                      child: Text('Guardar', style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white , fontSize: 20),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(ColorsPalet.primaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, TextEditingController controller,
      String errorMessage, FocusNode focusNode) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: isEditing
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title == "Edad")
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                // Mostrar el texto calculado de la edad
                _calculateAge(),
                style: TextStyle(fontSize: 16),
              ),
            )
          else
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              style: TextStyle(fontSize: 16.0),
              keyboardType:
              title == "Celular" || title == "Edad" ? TextInputType.number : null,
              onChanged: (value) {
                setState(() {
                  if (title == "Nombre") {
                    if (!_isTextValid(value)) {
                      nombreErrorMessage = 'Solo se permiten letras.';
                    } else {
                      nombreErrorMessage = '';
                    }
                  } else if (title == "Celular") {
                    if (!_isTextValid2(value)) {
                      celErrorMessage = 'Solo se permiten números.';
                    } else {
                      celErrorMessage = '';
                    }
                  } else if (title == "Correo electrónico") {
                    if (!_isEmailValid(value)) {
                      correoErrorMessage = 'Formato de correo no válido';
                    } else {
                      correoErrorMessage = '';
                    }
                  } else if (title == "Genero") {
                    if (!_isTextValid3(value)) {
                      generoErrorMessage = 'Solo se permiten letras.';
                    } else {
                      generoErrorMessage = '';
                    }
                  }
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: errorMessage.isNotEmpty ? Colors.red : Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: ColorsPalet.primaryColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          if (errorMessage.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 20,
                ),
                SizedBox(width: 5),
                Text(errorMessage,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w300)),
              ],
            ),
        ],
      )
          : Text(controller.text),
      trailing: null, // Eliminar completamente el icono de edición
    );
  }


  String _calculateAge() {
    // Verificar si la fecha de nacimiento está definida
    if (selectedDate != null) {
      // Calcular la edad
      final age = DateTime.now().difference(selectedDate!).inDays ~/ 365;
      return age.toString(); // Devolver la edad como una cadena
    } else {
      return '';
    }
  }

  Widget _buildDateSelectorTile(String title, DateTime? selectedDate) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: isEditing
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    // Mostrar la fecha seleccionada si está disponible, de lo contrario, mostrar "Seleccione una fecha"
                    selectedDate != null
                        ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                        : "Seleccione una fecha",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
      // Si no está editando, mostrar la edad en lugar de la fecha
          : Text(selectedDate != null
          ? _calculateAgeFromDate(selectedDate)
          : ""),
      trailing: null, // Eliminar completamente el icono de edición
    );
  }

  String _calculateAgeFromDate(DateTime? selectedDate) {
    if (selectedDate != null) {
      final age = DateTime.now().difference(selectedDate).inDays ~/ 365;
      return age.toString();
    } else {
      return '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorsPalet.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ColorsPalet.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        edadController.text = _calculateAgeFromDate(selectedDate);
      });
    }
  }

  bool _isTextValid(String text) {
    if (text.isEmpty) {
      return true;
    }
    final RegExp regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚ\s]+$');
    return regex.hasMatch(text);
  }

  bool _isTextValid2(String text) {
    if (text.isEmpty) {
      return true;
    }
    final RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(text);
  }

  bool _isEmailValid(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _isAgeValid(String age) {
    if (age.isEmpty) {
      return true;
    }

    final RegExp regex = RegExp(r'^\d+$');

    if (!regex.hasMatch(age)) {
      return false;
    }

    final int? ageValue = int.tryParse(age);

    return ageValue != null && ageValue >= 0 && ageValue < 110;
  }

  bool _isTextValid3(String text) {
    if (text.isEmpty) {
      return true;
    }
    final RegExp regex = RegExp(r'^[a-zA-Z0-9\sáéíóúÁÉÍÓÚ]+$');
    return regex.hasMatch(text);
  }

  bool _allErrorMessagesAreEmpty() {
    return nombreErrorMessage.isEmpty &&
        celErrorMessage.isEmpty &&
        correoErrorMessage.isEmpty &&
        generoErrorMessage.isEmpty &&
        edadErrorMessage.isEmpty;
  }
}
