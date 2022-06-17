class Actividad{

  //Atributos de la clase actividad
  int cod_actividad;
  String descripcion;
  String fecha_realizacion;
  String hora_inicio;
  String hora_final;

  //Constructor de la clase actividad
  Actividad({required this.cod_actividad, required this.descripcion, required this.fecha_realizacion,
      required this.hora_inicio, required this.hora_final});

  //Método que sirve para pasar los registros a un map
  Map<String, dynamic> toMap() {
    return {
      'descripcion': descripcion,
      'fecha_realizacion': fecha_realizacion,
      'hora_inicio': hora_inicio,
      'hora_final': hora_final,
    };
  }

  //Implementa toString para que sea más fácil ver información sobre cada actividad
  //usando la declaración de impresión
  @override
  String toString() {
    return 'Actividad{id: $cod_actividad, desc: $descripcion, fecha realización: $fecha_realizacion, hora inicio: $hora_inicio, final: $hora_final}';
  }

}