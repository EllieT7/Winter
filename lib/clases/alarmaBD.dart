import 'package:flutter/material.dart';

class AlarmaBD {

  //Atributos de la clase alarmBD
  int cod_alarma;
  String fecha;
  String hora;
  String descripcion;

  //Constructor de la clase alarmBD
  AlarmaBD({required this.cod_alarma, required this.fecha, required this.hora, required this.descripcion});

  //Método que sirve para pasar los registros a un map
  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'hora': hora,
      'descripcion': descripcion
    };
  }

}