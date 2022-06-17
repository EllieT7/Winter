class Tarea{

  //Atributos de la clase tarea
  int cod_tarea;
  String descripcion;
  String fecha_inicio;
  int terminada;

  //Constructor de la clase tarea
  Tarea({required this.cod_tarea, required this.descripcion, required this.fecha_inicio,
      required this.terminada});

  //Método que sirve para pasar los registros a un map
  Map<String, dynamic> toMap() {
    return {
      'descripcion': descripcion,
      'fecha_inicio': fecha_inicio,
      'terminada': terminada
    };
  }

  //Implementa toString para que sea más fácil ver información sobre cada actividad
  //usando la declaración de impresión
  @override
  String toString() {
    return 'Tarea{id: $cod_tarea, desc: $descripcion, inicio: $fecha_inicio, terminada: $terminada}';
  }

}