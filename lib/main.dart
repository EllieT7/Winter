import 'package:agenda_project/screens/screen_actividades.dart';
import 'package:agenda_project/screens/screen_alarmas.dart';
import 'package:agenda_project/screens/screen_inicio.dart';
import 'package:agenda_project/screens/screen_tareas.dart';
import 'package:flutter/material.dart';
import 'clases/actividad.dart';
import 'clases/alarm.dart';
import 'clases/tarea.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyAppStf(),
    );
  }
}

class MyAppStf extends StatefulWidget {
  const MyAppStf({Key? key}) : super(key: key);

  @override
  State<MyAppStf> createState() => _MyAppStfState();
}

class _MyAppStfState extends State<MyAppStf> {
  late List<Widget> _pages;
  late Widget _page0;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late int _currentIndex;
  late Widget _currentPage;
  List<Tarea> tareas = [];
  List <Alarm> alarms = [];
  List<Actividad> actividades = [];

  @override
  void initState() {
    super.initState();
    _page0 = ScreenMain(tareas, alarms, actividades);
    _page1 = ScreenWork(tareas);
    _page2 = ScreenActividades(actividades);
    _page3 = ScreenAlarm(alarms);
    _pages = [_page0, _page1, _page2, _page3];
    _currentIndex = 0;
    _currentPage = _page0;
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  void llenarListas(){
    var tarea1 = Tarea(cod_tarea: 1, descripcion: 'Tarea física', fecha_inicio: '2022-06-03', terminada: 0);
    var tarea2 = Tarea(cod_tarea: 2, descripcion: 'Tarea matemáticas', fecha_inicio: '2022-06-03', terminada: 0);
    if(tareas.isEmpty){
      tareas.add(tarea1); tareas.add(tarea2);
    } else {
      if(tareas.length == 1){
        tareas.add(tarea1);
      }
    }
    var actividad1 = Actividad(cod_actividad: 0,descripcion: 'Ir al gimnasio',fecha_realizacion: '2022-06-03', hora_inicio: '08:30', hora_final: '10:00',);
    var actividad2 = Actividad(cod_actividad: 0, descripcion: 'Comer fruta', fecha_realizacion: '2022-06-03', hora_inicio: '08:30', hora_final: '10:00',);
    if(actividades.isEmpty){
      actividades.add(actividad1); actividades.add(actividad2);
    } else if (actividades.length == 1){
      actividades.add(actividad1);
    }

    Alarm aux = Alarm(cod_alarma: 1, fecha: DateTime.now(), hora: TimeOfDay.now(), descripcion: 'Alarma 1');
    Alarm aux1 = Alarm(cod_alarma: 1, fecha: DateTime.now(), hora:  TimeOfDay.now(), descripcion: 'Alarma 2');

    if(alarms.isEmpty){
      alarms.add(aux); alarms.add(aux1);
    } else if (alarms.length == 1){
      alarms.add(aux);
    }
  }

  @override
  Widget build(BuildContext context) {
    llenarListas();
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.4),
              blurRadius: 25,
              offset: Offset(0.0, 0.75)
            )
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Inicio'),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/tareas.png')), label: 'Tareas'),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/horario.png')), label: 'Horario'),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/alarma.png')), label: 'Alarma'),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: const Color.fromRGBO(33, 150, 243, 100),
            unselectedItemColor: const Color.fromRGBO(169, 151, 196, 100),
            unselectedFontSize: 17,
            selectedFontSize: 17,
            iconSize: 30,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        )
    );
  }
}

