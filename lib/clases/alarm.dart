import 'package:flutter/material.dart';

class Alarm {

  //Atributos de la clase alarm
  int cod_alarma;
  DateTime fecha;
  TimeOfDay hora;
  String descripcion;

  //Constructor de la clase alarm
  Alarm({required this.cod_alarma, required this.fecha, required this.hora, required this.descripcion});

  //Método que sirve para pasar los registros a un map
  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'hora': hora,
      'descripcion': descripcion
    };
  }

}