import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../clases/operation.dart';
import '../clases/tarea.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class _MyList extends StatefulWidget {
  const _MyList({Key? key}) : super(key: key);

  @override
  State<_MyList> createState() => _MyListState();
}

class _MyListState extends State<_MyList> {
  List<Tarea> tareas = [];
  bool isChecked = false;

  @override
  void initState(){
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 2),
        child: ListTile(
          leading: Checkbox(
            activeColor: const Color.fromRGBO(169, 151, 196, 1),
            value: getBool(tareas[index].terminada),
            onChanged: (value) {
              setState(() {
                print(index);
                isChecked = value!;
                int terminada;
                if(tareas[index].terminada==1){
                  terminada = 0;
                }else{
                  terminada = 1;
                }
                var auxTarea = Tarea(cod_tarea: tareas[index].cod_tarea,
                    descripcion: tareas[index].descripcion,
                    fecha_inicio: tareas[index].fecha_inicio,
                    terminada: terminada);
                Operation.updateTarea(auxTarea);
                print("cambio $terminada");
              });
            },
          ),
          title: Text(tareas[index].descripcion, style: TextStyle(fontFamily: 'DidactGothic')),
          subtitle: Text(tareas[index].fecha_inicio),
          trailing: CircleAvatar(
            backgroundColor: const Color.fromRGBO(255, 212, 212, 1),
            radius: 15,
            child: IconButton(
              onPressed: (){
                setState(() {
                  Operation.deleteTarea(tareas[index].cod_tarea);
                  print("Eliminado" + tareas[index].cod_tarea.toString());
                });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
  _loadData () async{
    List<Tarea> auxTarea = await Operation.tareas();
    setState((){
      tareas = auxTarea;
    });
  }
  bool getBool(int i){
    bool result = false;
    if(i==1){
      result = true;
    }
    return result;
  }
}

class ScreenWork extends StatefulWidget {
  List<Tarea> works;
  ScreenWork(this.works);

  @override
  State<ScreenWork> createState() => _ScreenWorkState();
}

class _ScreenWorkState extends State<ScreenWork> {
  bool isChecked = false;
  List<Tarea> tareas = [];
  late DateTime _myDateTime;
  TextEditingController miVar = TextEditingController();
  TextEditingController valorFechaInicio = TextEditingController();
  TextEditingController valorFechaFinal = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void insertTarea(Tarea tarea){
    tareas.add(tarea);
    print('se agregó la tarea');
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda',
      home: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          backgroundColor:Colors.white ,
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
                    subtitle: Text('Esta frase te permitirá abrir el modal para agregar una nueva tarea.'),
                  ),
                ),
                const SizedBox(   //Espacio entre textos
                  height: 5,
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 2),
                  color: Colors.grey[100],
                  child: const ListTile(
                    title: Text('AÑADIR TAREA'),
                    subtitle: Text('Esta frase te permite agregar una nueva tarea utilizando la asistente por voz.'),
                  ),
                ),
                const SizedBox(   //Espacio entre textos
                  height: 5,
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 2),
                  color: Colors.grey[100],
                  child: const ListTile(
                    title: Text('ELIMINAR TAREA'),
                    subtitle: Text('Esta frase te permite eliminar una tarea utilizando la asistente por voz.'),
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
          backgroundColor: const Color.fromRGBO(226, 221, 235, 1),
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
                        color: Color.fromRGBO(226, 221, 235, 100),
                        width: 3.0,
                      ),
                    )
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/check.png', height: 35),
                    title: const Text(
                      'Todas las tareas',
                      style: TextStyle(
                          color: Color.fromRGBO(181, 156, 232, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand')
                    ),
                  ),
                ),
                const Expanded(
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
                  child: const Icon(Icons.mic, size: 30, color: Color.fromRGBO(169, 151, 196, 1),),
                  backgroundColor: const Color.fromRGBO(226, 221, 235, 1),
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
                  child: const Icon(Icons.add, size: 30,color: Color.fromRGBO(169, 151, 196, 1)),
                  backgroundColor: const Color.fromRGBO(226, 221, 235, 1),
                  onPressed: (){
                    modalAddTarea(context);
                  },
                ),
              ),
            ),
            // Add more floating buttons if you want
            // There is no limit
          ],
        ),
      ),
    );
  }
  _loadData () async{
    List<Tarea> auxTarea = await Operation.tareas();
    setState((){
      tareas = auxTarea;
    });
  }

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  FlutterTts flutertts = FlutterTts();
  bool eliminar = true;
  int controlador = 0;
  String descripcionTarea = '';
  String fechaInicioTarea = '';

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
            if(_text.contains('Abrir menú') || _text.contains('abrir menú')){
              modalAddTarea(context);
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
        } else if(_text.contains('Eliminar tarea')|| _text.contains('eliminar tarea')){
          _read('Ok!, dime el título de la tarea que quieres eliminar');
          eliminar = false;
          controlador = 0;
          _text = '';
        } else {
          if (eliminar) {
            if(controlador==0){
              if(_text.contains('añadir tarea') || _text.contains('Añadir tarea')){
                _read('Hola!, por favor dime el título de la tarea que quieres añadir');
                controlador = 1;
              } else {
                _read('Ocurrio un error puede repetir la orden por favor');
              }
            } else if (controlador==1){
              _read('Indique la fecha en la que se realizará la tarea. Ejemplo: 3 de Junio del 2022');
              descripcionTarea = _text;
              print('Descripcion: '+descripcionTarea);
              controlador = 2;
            } else {
              try {
                final splitter = _text.split(' ');
                print(splitter);
                _read('Indique el mes en el que se realizará la tarea');
                int dia = int.parse(splitter[0]);
                int anio = int.parse(splitter[4]);
                if(comprobarMes(splitter[2])>0){
                  int mes = comprobarMes(splitter[2]);
                  if(dia<10){
                    if(mes<10){
                      fechaInicioTarea = '0$dia-0$mes-$anio';
                    } else {
                      fechaInicioTarea = '0$dia-$mes-$anio';
                    }
                  } else {
                    if(mes<10){
                      fechaInicioTarea = '$dia-0$mes-$anio';
                    } else {
                      fechaInicioTarea = '$dia-$mes-$anio';
                    }
                  }
                  var aux = Tarea(cod_tarea: 2, descripcion: descripcionTarea, fecha_inicio: fechaInicioTarea, terminada: 0);
                  Operation.insertTarea(aux);
                  _read('La tarea se guardo de forma adecuada');
                  controlador = 0;
                } else {
                  _read("Ocurrio un error al comprobar el mes, intente de nuevo");
                }
              } on FormatException {
                _read("Ocurrio un error al comprobar el día o el año, por favor intente de nuevo");
              }
            }
            _text = '';
          } else {
            bool f = false;
            print('entro');
            for(int i=0;i<tareas.length;i++){
              if(tareas[i].descripcion.toUpperCase()==_text.toUpperCase()){
                setState((){
                  //tareas.removeAt(i);
                  Operation.deleteTarea(tareas[i].cod_tarea);
                  f = true;
                  print('Eliminado');
                  _read('Ok! se eliminó la tarea');
                });
              }
            }
            if (f){
              eliminar = true;
              _text = '';
            } else {
              _read('Tarea no encontrada intente de nuevo');
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

  modalAddTarea(BuildContext context){
    Widget okButton = TextButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(169, 151, 196, 1))),
        onPressed: () async{
          setState(() {
            Navigator.of(context).pop();
            print(miVar.text);
            var tarea = Tarea(
                cod_tarea: 1,
                descripcion: miVar.text,
                fecha_inicio: valorFechaInicio.text,
                terminada: 0
            );
            Operation.insertTarea(tarea);
            miVar.text='';
            valorFechaFinal.text = '';
            valorFechaInicio.text = '';
          });
          print(await Operation.tareas());
        },child: const Text('OK', style: TextStyle(fontSize: 15, color: Colors.white),)
    );
    Widget cancelButton = TextButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(255, 191, 176, 1))),
        onPressed: (){
          setState(() {
            Navigator.of(context).pop();
            miVar.text='';
            valorFechaFinal.text = '';
            valorFechaInicio.text = '';
          });
        },child: const Text('Cancelar', style: TextStyle(fontSize: 15, color: Colors.white),)
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Ingresar nueva tarea', style: TextStyle(color: Color.fromRGBO(56, 56, 56, 1))),
      content:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: <Widget>[
              const Text('Tarea:', style: TextStyle(fontSize: 14),),
              const SizedBox(width: 4,),
              Expanded(
                child: TextField(
                  style:const TextStyle(fontSize: 14),
                  controller: miVar,
                  decoration: const InputDecoration(
                    hintText: 'Ingresa una tarea',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(6),
                  ) ,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6,),
          Row(
            children: <Widget>[
              const Text('Fecha inicio:',style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4,),
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 14),
                  controller: valorFechaInicio,
                  keyboardType: TextInputType.none,
                  decoration: const InputDecoration(
                      hintText: 'Ingresa una fecha',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(6)
                  ) ,
                ),
              ),
              const SizedBox(width: 4,),
              SizedBox(
                  height: 30,
                  width: 30,
                  child: RawMaterialButton(
                      fillColor: const Color.fromRGBO(169, 151, 196, 1),
                      shape: const CircleBorder(),
                      elevation: 0.0,
                      child: const Icon(Icons.date_range, color: Colors.white, size: 17,),
                      onPressed: () async{
                        _myDateTime = (await showDatePicker(
                            firstDate: DateTime(2010),
                            initialDate: DateTime.now(),
                            context: context,
                            lastDate: DateTime(2030)
                        ))!;
                        setState((){
                          valorFechaInicio.text = DateFormat('dd-MM-yy').format(_myDateTime);
                        });
                      }
                  )
              )
            ],
          ),
        ],
      ),
      actions: [
        cancelButton,okButton
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false, //modal
      builder: (BuildContext dialogContext){
        return alert;
      },
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
      ..color = const Color.fromRGBO(230, 230, 230, 1)
      ..strokeWidth = 2;

    Paint circlePink = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(242, 217, 229, 1)
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(width*0.05, height*0.23), 100, circleGrey);
    canvas.drawCircle(Offset(width*0.9, height*0.7), 100, circlePink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
