// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UsuarioReport {

  int? id;
  String? nombre;
  String? celular;
  String? correoElectronico;
  String? genero;
  String? fechaNacimiento;
  int? edad;
  UsuarioReport({
    this.id,
    this.nombre,
    this.celular,
    this.correoElectronico,
    this.genero,
    this.fechaNacimiento,
    this.edad,
  });


  UsuarioReport copyWith({
    int? id,
    String? nombre,
    String? celular,
    String? correoElectronico,
    String? genero,
    String? fechaNacimiento,
    int? edad,
  }) {
    return UsuarioReport(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      celular: celular ?? this.celular,
      correoElectronico: correoElectronico ?? this.correoElectronico,
      genero: genero ?? this.genero,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      edad: edad ?? this.edad,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'celular': celular,
      'correoElectronico': correoElectronico,
      'genero': genero,
      'fechaNacimiento': fechaNacimiento,
      'edad': edad,
    };
  }

  factory UsuarioReport.fromMap(Map<String, dynamic> map) {
    return UsuarioReport(
      id: map['id'] != null ? map['id'] as int : null,
      nombre: map['nombre'] != null ? map['nombre'] as String : null,
      celular: map['celular'] != null ? map['celular'] as String : null,
      correoElectronico: map['correoElectronico'] != null ? map['correoElectronico'] as String : null,
      genero: map['genero'] != null ? map['genero'] as String : null,
      fechaNacimiento: map['fechaNacimiento'] != null ? map['fechaNacimiento'] as String : null,
      edad: map['edad'] != null ? map['edad'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioReport.fromJson(String source) => UsuarioReport.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UsuarioReport(id: $id, nombre: $nombre, celular: $celular, correoElectronico: $correoElectronico, genero: $genero, fechaNacimiento: $fechaNacimiento, edad: $edad)';
  }

  @override
  bool operator ==(covariant UsuarioReport other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.nombre == nombre &&
      other.celular == celular &&
      other.correoElectronico == correoElectronico &&
      other.genero == genero &&
      other.fechaNacimiento == fechaNacimiento &&
      other.edad == edad;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nombre.hashCode ^
      celular.hashCode ^
      correoElectronico.hashCode ^
      genero.hashCode ^
      fechaNacimiento.hashCode ^
      edad.hashCode;
  }
}

