import 'package:firebase_database/firebase_database.dart';

class User {
  String nombre;
  String apellido;    
  double paquetesPD;
  double precioPD;

  User(this.nombre, this.apellido, this.paquetesPD, this.precioPD);

  toJson() {
    return {
      "nombre": nombre,
      "apellido": apellido,
      "paquetesPD": paquetesPD,
      "precioPD": precioPD
    };
  }
}