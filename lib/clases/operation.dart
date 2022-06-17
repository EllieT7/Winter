import 'package:agenda_project/clases/tarea.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'actividad.dart';
import 'alarmaBD.dart';

class Operation{

  //Crea la base de datos, si esta no existe. O te devuelve la que exista
  static Future<Database> _openDB() async{
    return openDatabase(
      join(await getDatabasesPath(), 'prueba6.db'), onCreate: (db, version){
        db.execute("CREATE TABLE Tarea (cod_tarea integer NOT NULL CONSTRAINT Tarea_pk PRIMARY KEY AUTOINCREMENT,"+
            "descripcion text NOT NULL, fecha_inicio text NOT NULL, terminada integer NOT NULL);");
        db.execute("CREATE TABLE Actividad (cod_actividad integer NOT NULL CONSTRAINT Actividad_pk PRIMARY KEY AUTOINCREMENT,"+
            "descripcion text NOT NULL, fecha_realizacion text NOT NULL,hora_inicio text NOT NULL,hora_final text NOT NULL);");
        return db.execute("CREATE TABLE Alarma (cod_alarma integer NOT NULL CONSTRAINT Alarma_pk PRIMARY KEY AUTOINCREMENT,"+
            "fecha text NOT NULL, hora text NOT NULL,descripcion text NOT NULL);"
        );
      }, version: 1);
  }

  //Inserta a la tabla tarea el nuevo registro
  static Future<int> insertTarea(Tarea tarea) async{
    Database database = await _openDB();
    return database.insert("tarea", tarea.toMap());
  }

  //Ordena los registros de la mas proxima a la mas lejana por fechas
  static Future<List<Tarea>> tareas() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM tarea ORDER BY fecha_inicio ASC");;
    return List.generate(maps.length, (i) {
      return Tarea(
        cod_tarea: maps[i]['cod_tarea'],
        descripcion: maps[i]['descripcion'],
        fecha_inicio: maps[i]['fecha_inicio'],
        terminada: maps[i]['terminada']
      );
    });
  }

  //Actualiza el estado de la tarea, si esta terminada o no
  static Future<int> updateTarea(Tarea tarea) async {
    Database db = await _openDB();
    return db.update(
      'tarea',
      tarea.toMap(),
      where: "cod_tarea = ?",
      whereArgs: [tarea.cod_tarea],
    );
  }

  //Elimina la tarea en base a su cod/id
  static Future<int> deleteTarea(int id) async {
    Database db = await _openDB();
    return db.delete(
      'tarea',
      where: "cod_tarea = ?",
      whereArgs: [id],
    );
  }

  //Inserta a la tabla actividad el nuevo registro
  static Future<int> insertActividad(Actividad actividad) async{
    Database database = await _openDB();
    return database.insert("actividad", actividad.toMap());
  }

  //Ordena los registros de la mas proxima a la mas lejana por fechas
  static Future<List<Actividad>> actividades() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM actividad ORDER BY fecha_realizacion ASC");
    return List.generate(maps.length, (i) {
      return Actividad(
          cod_actividad: maps[i]['cod_actividad'],
          descripcion: maps[i]['descripcion'],
          fecha_realizacion: maps[i]['fecha_realizacion'],
          hora_inicio: maps[i]['hora_inicio'],
          hora_final: maps[i]['hora_final']
      );
    });
  }

  //Update actividad
  static Future<int> updateActividad(Actividad actividad) async {
    Database db = await _openDB();
    return db.update(
      'actividad',
      actividad.toMap(),
      where: "cod_actividad = ?",
      whereArgs: [actividad.cod_actividad],
    );
  }

  //Elimina la actividad en base a su cod/id
  static Future<int> deleteActividad(int id) async {
    Database db = await _openDB();
    return db.delete(
      'actividad',
      where: "cod_actividad = ?",
      whereArgs: [id],
    );
  }

  //Devuelve los primeros dos registros si es que existen, de la tabla tarea
  static Future<List<Tarea>> tareas2() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM tarea ORDER BY fecha_inicio ASC LIMIT 2");
    return List.generate(maps.length, (i) {
      return Tarea(
          cod_tarea: maps[i]['cod_tarea'],
          descripcion: maps[i]['descripcion'],
          fecha_inicio: maps[i]['fecha_inicio'],
          terminada: maps[i]['terminada']
      );
    });
  }

  //Devuelve los primeros dos registros si es que existen, de la tabla actividad
  static Future<List<Actividad>> actividades2() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM actividad ORDER BY fecha_realizacion ASC LIMIT 2");
    return List.generate(maps.length, (i) {
      return Actividad(
          cod_actividad: maps[i]['cod_actividad'],
          descripcion: maps[i]['descripcion'],
          fecha_realizacion: maps[i]['fecha_realizacion'],
          hora_inicio: maps[i]['hora_inicio'],
          hora_final: maps[i]['hora_final']
      );
    });
  }

  //Devuelve los primeros dos registros si es que existen, de la tabla alarma
  static Future<List<AlarmaBD>> alarmas2() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM alarma ORDER BY fecha ASC LIMIT 2");
    return List.generate(maps.length, (i) {
      return AlarmaBD(
          cod_alarma: maps[i]['cod_alarma'],
          fecha: maps[i]['fecha'],
          hora: maps[i]['hora'],
          descripcion: maps[i]['descripcion']
      );
    });
  }

  //Alarmas
  //Inserta a la alarma tarea el nuevo registro
  static Future<int> insertAlarma(AlarmaBD alarma) async{
    Database database = await _openDB();
    return database.insert("alarma", alarma.toMap());
  }

  //Ordena los registros de la mas proxima a la mas lejana por fechas
  static Future<List<AlarmaBD>> alarmas() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM alarma ORDER BY fecha ASC");
    return List.generate(maps.length, (i) {
      return AlarmaBD(
          cod_alarma: maps[i]['cod_alarma'],
          fecha: maps[i]['fecha'],
          hora: maps[i]['hora'],
          descripcion: maps[i]['descripcion']
      );
    });
  }

  //Update alarma
  static Future<int> updateAlarma(AlarmaBD alarma) async {
    Database db = await _openDB();
    return db.update(
      'alarma',
      alarma.toMap(),
      where: "cod_alarma = ?",
      whereArgs: [alarma.cod_alarma],
    );
  }

  //Elimina la alarma en base a su cod/id
  static Future<int> deleteAlarma(int id) async {
    Database db = await _openDB();
    return db.delete(
      'alarma',
      where: "cod_alarma = ?",
      whereArgs: [id],
    );
  }

}