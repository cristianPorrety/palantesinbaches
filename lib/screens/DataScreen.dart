import 'package:flutter/material.dart';
import 'package:pilasconelhueco/home/homepage.dart';
import 'package:pilasconelhueco/shared/styles.dart';
import '../shared/labels.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  // Controladores para los campos de texto
  TextEditingController nombreController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController correoElectronicoController = TextEditingController();
  TextEditingController generoController = TextEditingController();
  TextEditingController edadController = TextEditingController();

  bool isEditing = false; // Variable para controlar si se está editando o no

  @override
  void initState() {
    // Inicializa los controladores con valores iniciales vacíos
    nombreController.text = "";
    celularController.text = "";
    correoElectronicoController.text = "";
    generoController.text = "";
    edadController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    // Libera los recursos de los controladores cuando se destruye el widget
    nombreController.dispose();
    celularController.dispose();
    correoElectronicoController.dispose();
    generoController.dispose();
    edadController.dispose();
    super.dispose();
  }

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
                    child: Icon(Icons.camera_alt, color: Colors.grey, size: 30,),
                  ),
                ],
              ),
            ),
            _buildListTile("Nombre", nombreController),
            _buildListTile("Celular", celularController),
            _buildListTile("Correo electrónico", correoElectronicoController),
            _buildListTile("Genero", generoController),
            _buildListTile("Edad", edadController),
            Padding(
              padding: EdgeInsets.only(top: 70.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = false; // Desactivar edición al guardar
                    });
                    // Aquí puedes agregar lógica para guardar los cambios
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

  Widget _buildListTile(String title, TextEditingController controller) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: isEditing
          ? TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: ColorsPalet.primaryColor),
          ),
        ),
      )
          : Text(controller.text),
      trailing: InkWell(
        onTap: () {
          setState(() {
            isEditing = true;
          });
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
