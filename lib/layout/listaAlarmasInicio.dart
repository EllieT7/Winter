import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../clases/alarm.dart';
import '../clases/alarmaBD.dart';
import '../clases/operation.dart';

class ListaAlarmas extends StatefulWidget {
  const ListaAlarmas({Key? key}) : super(key: key);

  @override
  State<ListaAlarmas> createState() => _ListaAlarmasState();
}

class _ListaAlarmasState extends State<ListaAlarmas> {
  List<Alarm> alarms = [];
  List<Color> colores = [Color.fromRGBO(211, 240, 210, 1),Color.fromRGBO(238, 235, 245, 1)];
  List<Color> coloresText = [Color.fromRGBO(63, 157, 47, 1),Color.fromRGBO(113, 86, 150, 1)];

  @override
  void initState(){
    _loadData();
    super.initState();
  }
  _loadData () async{
    List<AlarmaBD> auxAlarma= await Operation.alarmas2();
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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: alarms.length,
        itemBuilder: (context, index) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
          elevation: 3,
          color: colores[index%2],
          child: ListTile(
            leading: Image.asset('assets/reloj.png', height: 35),
            title: Text('${alarms[index].descripcion} ', style:  TextStyle(color: coloresText[index%2], fontFamily: 'DidactGothic'),),
            subtitle: Text('${DateFormat('dd-MM-yyyy').format(alarms[index].fecha)} ${alarms[index].hora.hour}:${alarms[index].hora.minute}', style: const TextStyle(color: Color.fromRGBO(113, 113, 113, 1)),),
          ),
        ),
    );
  }
}

