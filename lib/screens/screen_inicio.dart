import 'package:agenda_project/layout/listaActividadesInicio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../clases/actividad.dart';
import '../clases/alarm.dart';
import '../clases/operation.dart';
import '../clases/tarea.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../layout/listaAlarmasInicio.dart';
import '../layout/listaTareasInicio.dart';

class ScreenMain extends StatefulWidget {
  List<Tarea> works;
  List <Alarm> alarmas;
  List<Actividad> activities;
  ScreenMain(this.works, this. alarmas, this.activities);

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  DateTime _myDateTime = DateTime.now();
  List<Tarea> tareas = [];
  List <Alarm> alarms = [];
  List<Actividad> actividades = [];
  bool isChecked = false;

  @override
  void initState() {
    _loadData();
    super.initState();
    _speech = stt.SpeechToText();
  }
  _loadData () async{
    List<Tarea> auxTarea = await Operation.tareas2();
    setState((){
      tareas = auxTarea;
    });
  }

  @override
  Widget build(BuildContext context) {
    //tareas = widget.works;
    _loadData();
    alarms = widget.alarmas;
    actividades = widget.activities;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(170, 218, 199, 1),
        buttonTheme: ButtonTheme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
              secondary: Color.fromRGBO(170, 218, 199, 1)
          ),
        ),
          scaffoldBackgroundColor: Colors.white
      ),
      home: Scaffold(
        drawer: Drawer(
          child: Container(
            color: Colors.white, //Color de fondo del drawer
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top:20, bottom: 0),
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,//Toma el largo horizontal
                  //color: Colors.grey[100], //Color de fondo
                  child: Column(
                    children: const [
                      Text(
                        'Bienvenid@',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Estas son las frases que puedes utilizar para realizar acciones en la aplicación sin necesidad de escribir :)',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 2),
                  color: Colors.grey[100],
                  child: const ListTile(
                    title: Text('QUÉ DÍA ES HOY'),
                    subtitle: Text('Esta frase te permitirá activar a la asistente por voz y te dirá el día en que te encuentras.'),
                  ),
                ),
                const SizedBox(   //Espacio entre textos
                  height: 5,
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 2),
                  color: Colors.grey[100],
                  child: const ListTile(
                    title: Text('QUÉ FECHA ES HOY'),
                    subtitle: Text('Esta frase te permitirá activar a la asistente por voz y te dirá la fecha en la que te encuentras.'),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(170, 218, 199, 1),
        ),
        body: SingleChildScrollView(
          child: CustomPaint(
            painter: BluePainter(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [
                Container(
                  margin: const EdgeInsets.only(top: 40, right: 30, left: 30),
                  decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(207, 207, 207, 1),
                          width: 3.0,
                        ),
                      )
                  ),
                  child: Column(
                    children: <Widget> [
                      Row(
                        children: [
                          Image.asset('assets/panda_rojo.png', height: 100,),
                          const Text(' Bienvenid@!', style: TextStyle(color: Color.fromRGBO(113, 113, 113, 1), fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Quicksand')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Image.asset(getImageTime(_myDateTime.hour), height: 150, ),
                      Text(dayWeekend(_myDateTime.weekday), style: const TextStyle(color: Color.fromRGBO(113, 113, 113, 1), fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'DidactGothic')),
                      Text(DateFormat('dd-MM-yyyy').format(_myDateTime), style: const TextStyle(color: Color.fromRGBO(113, 113, 113, 1), fontSize: 20, fontFamily: 'DidactGothic')),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, right: 30, left: 30),
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
                    children: <Widget> [
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color.fromRGBO(226, 221, 235, 1), width: 3.0,),
                            )
                        ),
                        child: ListTile(
                          title: const Text('Tareas a realizar',
                            style: TextStyle(color: Color.fromRGBO(255, 204, 163, 1), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Quicksand',),
                          ),
                          trailing: Image.asset('assets/check.png', height: 30,),
                        ),
                      ),
                      ListTareas(),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25, right: 30, left: 30, bottom: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(207, 207, 207, 1),
                        width: 3.0,
                      ),
                      top: BorderSide(
                        color: Color.fromRGBO(207, 207, 207, 1),
                        width: 3.0,
                      ),
                    )
                  ),
                  child: Column(
                    children: <Widget> [
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: ListTile(
                          leading: Image.asset('assets/manzana.png', height: 35,),
                          title: const Text('Actividades a realizar',
                            style: TextStyle(color: Color.fromRGBO(189, 221, 135, 1), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Quicksand',),
                          ),
                        ),
                      ),
                      ListaActividades(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 30, left: 30, bottom: 30),
                  child: Column(
                    children: <Widget> [
                      ListTile(
                        title: const Text('Alarmas programadas',
                          style: TextStyle(color: Color.fromRGBO(247, 186, 123, 1), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Quicksand',),
                        ),
                        trailing: Image.asset('assets/calendario.png', height: 40,),
                      ),
                      ListaAlarmas(),
                    ],
                  ),
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
                  child: const Icon(Icons.mic, size: 30,color: Color.fromRGBO(67, 157, 187, 1),),
                  backgroundColor: const Color.fromRGBO(216, 237, 243, 1),
                  onPressed: _listen,
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
  String _text = '';
  FlutterTts flutertts = FlutterTts();

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
          onResult: (val) => setState(() async {
            _text = val.recognizedWords;
            print(_text);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if(_text.isEmpty){
        _read('No se le escuchó, puede repetir por favor');
      } else {
        if(_text.contains('Qué día es hoy') || _text.contains('qué día es hoy')){
          _read('Hoy es '+dayWeekend(_myDateTime.weekday));
        } else if (_text.contains('Qué fecha es hoy') || _text.contains('qué fecha es hoy')){
          _read('La fecha de hoy es '+DateFormat('dd-MM-yyyy').format(_myDateTime));
        } else {
          _read('Ocurrio un error puede repetir la orden por favor');
        }
      }
      _text = '';
    }
  }

  String dayWeekend(int n){
    String aux = '';
    switch (n){
      case 1: aux = 'Lunes'; break;
      case 2: aux = 'Martes'; break;
      case 3: aux = 'Miércoles'; break;
      case 4: aux = 'Jueves'; break;
      case 5: aux = 'Viernes'; break;
      case 6: aux = 'Sábado'; break;
      case 7: aux = 'Domingo'; break;
    }
    return aux;
  }

  String getImageTime(int hrs){
    String aux = '';
    if(hrs>=6 && hrs<11){
      aux = 'assets/mañana.png';
    } else if (hrs>=12 && hrs<19){
      aux = 'assets/tarde.png';
    } else {
      aux = 'assets/noche.png';
    }
    return aux;
  }

}

//Circulos decorativos
class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    Paint circleGrey = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(250, 232, 218, 1)
      ..strokeWidth = 2;

    Paint circlePink = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(245, 214, 199, 1)
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(width*0.08, height*0.08), 100, circleGrey);
    canvas.drawCircle(Offset(width*0.9, height*0.3), 100, circlePink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}


