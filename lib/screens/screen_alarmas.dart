import 'dart:async';
import 'package:agenda_project/clases/operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import '../clases/alarm.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../clases/alarmaBD.dart';

class _MyList extends StatefulWidget {
  const _MyList({Key? key}) : super(key: key);

  @override
  State<_MyList> createState() => _MyListState();
}

class _MyListState extends State<_MyList> {
  List <Alarm> alarms = [];
  List <Color> colorBack = [const Color.fromRGBO(255, 237, 237, 1), const Color.fromRGBO(255, 240, 227, 1), const Color.fromRGBO(252, 249, 221, 1), const Color.fromRGBO(241, 250, 240, 1), const Color.fromRGBO(230, 247, 250, 1), const Color.fromRGBO(240, 237, 247, 1)];
  List <Color> colorLetter = [const Color.fromRGBO(173, 66, 60, 1), const Color.fromRGBO(245, 164, 77, 1), const Color.fromRGBO(179, 168, 16, 1), const Color.fromRGBO(143, 174, 45, 1), const Color.fromRGBO(67, 157, 187, 1), const Color.fromRGBO(113, 86, 150, 1)];
  List<int> indexEjecutados = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState(){
    _loadData();
    super.initState();
    var initializationSettingsAndroid = const AndroidInitializationSettings('panda');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    });
  }
  Future _showNotificationWithDefaultSound(String title) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high,
        icon: 'panda');
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      'Ya es hora de completar tu actividad 🥳',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
  @override
  Widget build(BuildContext context) {
    _loadData();
    Timer miTimer = Timer.periodic(const Duration(seconds: 10),(timer){
      //El codigo se ejecuta cada 30 seg
      for(int i=0;i<alarms.length;i++){
        //print('hola $i');
        //print(TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute).toString());
        //print(DateTime.now().toString());
        if(alarms[i].hora == TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute) && alarms[i].fecha.day == DateTime.now().day && alarms[i].fecha.month == DateTime.now().month && alarms[i].fecha.year == DateTime.now().year){
          if(!indexEjecutados.contains(i)){
            indexEjecutados.add(i);
            print('es hora');
            _showNotificationWithDefaultSound(alarms[i].descripcion);
          }
        }
      }
    });
    return ListView.builder(
      itemCount: alarms.length,
      itemBuilder: (context, index) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
        elevation: 3,
        color: colorBack[index%6],
        child: ListTile(
          leading: Image.asset('assets/reloj.png', height: 35),
          title: Text('${alarms[index].descripcion} ', style: TextStyle(color: colorLetter[index%6], fontFamily: 'DidactGothic'),),
          subtitle: Text('${DateFormat('dd-MM-yyyy').format(alarms[index].fecha)} ${alarms[index].hora.hour}:${alarms[index].hora.minute}', style: const TextStyle(color: Color.fromRGBO(113, 113, 113, 1)),),
          trailing: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: IconButton(
              onPressed: (){
                setState(() {
                  //alarms.removeWhere((element) => (element == alarms[index]));
                  Operation.deleteAlarma(alarms[index].cod_alarma);
                  indexEjecutados.remove(index);
                });
              },
              icon: const Icon(
                Icons.delete,
                color: Color.fromRGBO(173, 66, 60, 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _loadData () async{
    List<AlarmaBD> auxAlarma= await Operation.alarmas();
    List<Alarm> cambioAlarmas = cambiarTipoDatos(auxAlarma);
    setState((){
      alarms = cambioAlarmas;
    });
  }

  List<Alarm> cambiarTipoDatos(List<AlarmaBD> listaInicial){
    List<Alarm> lista = [];
    for(int i=0; i<listaInicial.length; i++){
      AlarmaBD dato = listaInicial[i];
      final splitter = dato.fecha.split('-');
      print(splitter);
      int dia = int.parse(splitter[0]);
      int anio = int.parse(splitter[2]);
      int mes = int.parse(splitter[1]);
      DateTime nuevaFecha = DateTime.utc(anio, mes, dia);
      final splitterHora = dato.hora.split(':');
      print(splitterHora);
      int hora = int.parse(splitterHora[0]);
      int min = int.parse(splitterHora[1]);
      TimeOfDay nuevaHora = TimeOfDay(hour: hora, minute: min);
      var alarma = Alarm(cod_alarma: dato.cod_alarma, fecha: nuevaFecha, hora: nuevaHora, descripcion: dato.descripcion);
      lista.add(alarma);
    }
    return lista;
  }

}



class ScreenAlarm extends StatefulWidget {
  List <Alarm> alarmas;
  ScreenAlarm(this.alarmas);

  @override
  State<ScreenAlarm> createState() => _ScreenAlarmState();
}

class _ScreenAlarmState extends State<ScreenAlarm> {

  List <Alarm> alarms = [];
  TextEditingController date = TextEditingController();
  TextEditingController hour = TextEditingController();
  TextEditingController name = TextEditingController();
  DateTime _myDateTime = DateTime.now();
  TimeOfDay _myHourTime = TimeOfDay.now();


  @override
  void initState(){
    super.initState();
    _speech = stt.SpeechToText();

  }
  _loadData () async{
    List<AlarmaBD> auxAlarma= await Operation.alarmas();
    List<Alarm> cambioAlarmas = cambiarTipoDatos(auxAlarma);
    setState((){
      alarms = cambioAlarmas;
    });
  }

  List<Alarm> cambiarTipoDatos(List<AlarmaBD> listaInicial){
    List<Alarm> lista = [];
    for(int i=0; i<listaInicial.length; i++){
      AlarmaBD dato = listaInicial[i];
      final splitter = dato.fecha.split('-');
      print(splitter);
      int dia = int.parse(splitter[0]);
      int anio = int.parse(splitter[2]);
      int mes = int.parse(splitter[1]);
      DateTime nuevaFecha = DateTime.utc(anio, mes, dia);
      final splitterHora = dato.hora.split(':');
      print(splitterHora);
      int hora = int.parse(splitterHora[0]);
      int min = int.parse(splitterHora[1]);
      TimeOfDay nuevaHora = TimeOfDay(hour: hora, minute: min);
      var alarma = Alarm(cod_alarma: dato.cod_alarma, fecha: nuevaFecha, hora: nuevaHora, descripcion: dato.descripcion);
      lista.add(alarma);
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    //alarms = widget.alarmas;
    _loadData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda',
      theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
      home: Scaffold(
        drawer: Drawer(
          child: Container(
            color: Colors.white, //Color de fondo del drawer
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top:25),
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,//Toma el largo horizontal
                  //color: Colors.grey[100], //Color de fondo
                  child: Column(
                    children: const [
                      Text(
                        'Bienvenid@',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(   //Espacio entre textos
                        height: 10,
                      ),
                      Text(
                        'Estas son las frases que puedes utilizar para realizar acciones en la aplicación sin necesidad de escribir :)',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(   //Espacio entre textos
                        height: 10,
                      ),
                      Text(
                        'No olvides que después de activar alguna opción debes seguir las instrucciones de la asistente por voz.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 2),
                  color: Colors.grey[100],
                  child: const ListTile(
                    title: Text('ABRIR MENU'),
                    subtitle: Text('Esta frase te permitirá abrir el modal para agregar una nueva alarma.'),
                  ),
                ),
                const SizedBox(   //Espacio entre textos
                  height: 5,
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 2),
                  color: Colors.grey[100],
                  child: const ListTile(
                    title: Text('AÑADIR ALARMA'),
                    subtitle: Text('Esta frase te permite agregar una nueva alarma utilizando la asistente por voz.'),
                  ),
                ),
                const SizedBox(   //Espacio entre textos
                  height: 5,
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 2),
                  color: Colors.grey[100],
                  child: const ListTile(
                    title: Text('ELIMINAR ALARMA'),
                    subtitle: Text('Esta frase te permite eliminar una alarma utilizando la asistente por voz.'),
                  ),
                ),
                const SizedBox(   //Espacio entre textos
                  height: 5,
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 2),
                  color: Colors.grey[100],
                  child: const ListTile(
                    title: Text('CANCELAR'),
                    subtitle: Text('Esta frase te permite cancelar cualquier proceso en cualquier momento.'),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 204, 163, 1),
        ),
        body: CustomPaint(
          painter: BluePainter(),
          child: Container(
            margin: const EdgeInsets.only(top: 25, right: 35, left: 35, bottom: 25),
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    offset: Offset(0, 0.75),
                    blurRadius: 25
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(226, 221, 235, 1),
                          width: 3.0,
                        ),
                      )
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/cactus.png', height: 44),
                    title: const Text(
                      'Todas las alarmas',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 204, 163, 1),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _MyList()
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Stack(
          children: [
            Positioned(
              right: 15,
              top: 90,
              child: SizedBox(
                height: 50,
                width: 50,
                child: FloatingActionButton(
                  child: const Icon(Icons.mic, size: 30,color: Color.fromRGBO(255, 148, 66, 1),),
                  backgroundColor: const Color.fromRGBO(255, 204, 163, 1),
                  onPressed: _listen,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 40,
              child: SizedBox(
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  child: const Icon(Icons.add, size: 30, color: Color.fromRGBO(255, 148, 66, 1),),
                  backgroundColor: const Color.fromRGBO(255, 204, 163, 1),
                  onPressed: (){
                    modalAlarma();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Presiona el botón y empieza a hablar';
  FlutterTts flutertts = FlutterTts();
  bool eliminar = true;
  int controlador = 0;
  String descripcionAlarma = '';
  int hora = -1;
  late DateTime fechaAlarma;
  late TimeOfDay horaAlarma;

  void _read (String text) async{
    await flutertts.setLanguage('es-ES');
    await flutertts.setPitch(1);
    await flutertts.speak(text);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
            if(_text.contains('Abrir menú') || _text.contains('abrir menú')){
              modalAlarma();
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      print(_text);
      print(controlador);
      if(_text.isEmpty){
        _read('No se le escuchó, puede repetir por favor');
      } else {
        if (_text.contains('cancelar') || _text.contains('Cancelar')){
          _read('Proceso cancelado');
          controlador = 0;
          eliminar = true;
          _text = '';
        } else if(_text.contains('Eliminar alarma')|| _text.contains('eliminar alarma')){
          _read('Ok!, dime la descripción de la alarma que quieres eliminar');
          eliminar = false;
          controlador = 0;
          _text = '';
        } else {
          if (eliminar) {
            if(controlador==0){
              if(_text.contains('añadir alarma') || _text.contains('Añadir alarma')){
                _read('Hola!, por favor dime la descripción de la alarma que quieres añadir');
                controlador = 1;
              } else {
                _read('Ocurrio un error puede repetir la orden por favor');
              }
            } else if (controlador==1){
              _read('Indique la fecha en la que se mandará la alarma. Ejemplo: 3 de Junio del 2022');
              descripcionAlarma = _text;
              print('Descripcion: '+descripcionAlarma);
              controlador = 2;
            } else if (controlador==2){
              try {
                final splitter = _text.split(' ');
                print(splitter);
                _read('Indique solo la hora cuando se le debe mandar la alarma');
                int dia = int.parse(splitter[0]);
                int anio = int.parse(splitter[4]);
                if(comprobarMes(splitter[2])>0){
                  int mes = comprobarMes(splitter[2]);
                  fechaAlarma = DateTime.utc(anio, mes, dia);
                  controlador = 3;
                } else {
                  _read("Ocurrio un error al comprobar el mes, intente de nuevo");
                }
              } on FormatException {
                _read("Ocurrio un error al comprobar el día o el año, por favor intente de nuevo");
              }
            } else if (controlador==3) {
              try {
                hora = int.parse(_text);
                _read('Indique solo los minutos cuando se le debe mandar la alarma');
                controlador = 4;
              } on FormatException {
                _read("No es una hora, por favor intente de nuevo");
              }
            } else {
              try {
                int min = int.parse(_text);
                horaAlarma = TimeOfDay(hour: hora, minute: min);
                String nuevaFecha = DateFormat('dd-MM-yyyy').format(fechaAlarma);
                String nuevaHora = "${horaAlarma.hour}:${horaAlarma.minute}";
                AlarmaBD auxBD = AlarmaBD(cod_alarma: 1, fecha: nuevaFecha, hora: nuevaHora, descripcion: name.text.toString());
                Operation.insertAlarma(auxBD);
                _read('La alarma se guardo adecuadamente');
                controlador = 0;
              } on FormatException {
                _read("No son minutos, por favor intente de nuevo");
              }
            }
            _text = '';
          } else {
            bool f = false;
            print('entro');
            for(int i=0;i<alarms.length;i++){
              if(alarms[i].descripcion.toUpperCase()==_text.toUpperCase()){
                setState((){
                  Operation.deleteAlarma(alarms[i].cod_alarma);
                  f = true;
                  print('Eliminado');
                  _read('Ok! se eliminó la alarma');
                });
              }
            }
            if (f){
              eliminar = true;
              _text = '';
            } else {
              _read('Alarma no encontrada intente de nuevo');
            }
          }
        }
      }
    }
  }

  int comprobarMes(String mes){
    int flag = -1;
    switch(mes){
      case 'Enero': flag = 1; break;
      case 'enero': flag = 1; break;
      case 'Febrero': flag = 2; break;
      case 'febrero': flag = 2; break;
      case 'Marzo': flag = 3; break;
      case 'marzo': flag = 3; break;
      case 'Abril': flag = 4; break;
      case 'abril': flag = 4; break;
      case 'Mayo': flag = 5; break;
      case 'mayo': flag = 5; break;
      case 'Junio': flag = 6; break;
      case 'junio': flag = 6; break;
      case 'Julio': flag = 7; break;
      case 'julio': flag = 7; break;
      case 'Agosto': flag = 8; break;
      case 'agosto': flag = 8; break;
      case 'Septiembre': flag = 9; break;
      case 'septiembre': flag = 9; break;
      case 'Octubre': flag = 10; break;
      case 'octubre': flag = 10; break;
      case 'Noviembre': flag = 11; break;
      case 'noviembre': flag = 11; break;
      case 'Diciembre': flag = 12; break;
      case 'diciembre': flag = 12; break;
    }
    return flag;
  }

  modalAlarma(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Programa tu alarma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Fecha: ', style: TextStyle(color: Colors.grey),),
                Expanded(
                    child: TextFormField(
                      controller: date,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: 'Ingresa una fecha',
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                        ),
                      ),
                    )
                ),
                CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  radius: 20,
                  child: IconButton(
                    onPressed: () async {
                      _myDateTime = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2030)
                      ))!;
                      setState(() {
                        date.text = DateFormat('dd-MM-yyyy').format(_myDateTime);
                      });
                    },
                    icon: const Icon(Icons.calendar_today_outlined, color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Hora: ', style: TextStyle(color: Colors.grey),),
                Expanded(
                    child: TextFormField(
                      controller: hour,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: 'Ingresa una hora',
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                        ),
                      ),
                    )
                ),
                CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  radius: 20,
                  child: IconButton(
                    onPressed: () async {
                      _myHourTime = (await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now()
                      ))!;
                      setState(() {
                        hour.text = '${_myHourTime.hour}:${_myHourTime.minute}';
                      });
                    },
                    icon: const Icon(Icons.access_alarm, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          FlatButton(
              onPressed: (){
                setState(() {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Programa tu alarma'),
                        content: TextField(
                          controller: name,
                          decoration: InputDecoration(
                            hintText: 'Ingresar el nombre de la alarma',
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: (){
                                setState(() {
                                  //Alarm aux = Alarm(cod_alarma: 1, fecha: _myDateTime, hora: _myHourTime, descripcion: name.text.toString());
                                  String fecha = DateFormat('dd-MM-yyyy').format(_myDateTime);
                                  String hora = "${_myHourTime.hour}:${_myHourTime.minute}";
                                  AlarmaBD auxBD = AlarmaBD(cod_alarma: 1, fecha: fecha, hora: hora, descripcion: name.text.toString());
                                  //alarms.add(aux);
                                  Operation.insertAlarma(auxBD);
                                  Navigator.of(context).pop();
                                  hour.text = '';
                                  date.text = '';
                                  name.text = '';
                                });
                              },
                              child: const Text('Ok')
                          )
                        ],
                      )
                  );
                });
              },
              child: const Text('Ok')
          )
        ],
      ),
    );
  }
}

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    Paint circleGrey = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(226, 221, 235, 1)
      ..strokeWidth = 2;

    Paint circlePink = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(245, 214, 199, 1)
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(width*0.05, height*0.23), 100, circleGrey);
    canvas.drawCircle(Offset(width*0.9, height*0.7), 100, circlePink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
