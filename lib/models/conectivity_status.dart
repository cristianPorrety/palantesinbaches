// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';





class ConectivityStatus {
  bool? connected;

  ConectivityStatus({
    this.connected,
  });


  ConectivityStatus copyWith({
    bool? connected,
  }) {
    return ConectivityStatus(
      connected: connected ?? this.connected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'connected': connected,
    };
  }

  factory ConectivityStatus.fromMap(Map<String, dynamic> map) {
    return ConectivityStatus(
      connected: map['connected'] != null ? map['connected'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConectivityStatus.fromJson(String source) => ConectivityStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ConectivityStatus(connected: $connected)';

  @override
  bool operator ==(covariant ConectivityStatus other) {
    if (identical(this, other)) return true;
  
    return 
      other.connected == connected;
  }

  @override
  int get hashCode => connected.hashCode;
}

