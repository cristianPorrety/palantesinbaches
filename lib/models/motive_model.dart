// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MotiveModel {

  String? code;
  String? name;
  MotiveModel({
    this.code,
    this.name,
  });


  MotiveModel copyWith({
    String? code,
    String? name,
  }) {
    return MotiveModel(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'name': name,
    };
  }

  factory MotiveModel.fromMap(Map<String, dynamic> map) {
    return MotiveModel(
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MotiveModel.fromJson(String source) => MotiveModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MotiveModel(code: $code, name: $name)';

  @override
  bool operator ==(covariant MotiveModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.code == code &&
      other.name == name;
  }

  @override
  int get hashCode => code.hashCode ^ name.hashCode;
}

