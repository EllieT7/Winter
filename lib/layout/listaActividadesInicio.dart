import 'package:flutter/material.dart';
import '../clases/actividad.dart';
import '../clases/operation.dart';

class ListaActividades extends StatefulWidget {
  const ListaActividades({Key? key}) : super(key: key);

  @override
  State<ListaActividades> createState() => _ListaActividadesState();
}

class _ListaActividadesState extends State<ListaActividades> {
  List<Actividad> actividades = [];
  List<Color> colores = [Color.fromRGBO(245, 214, 199, 1),Color.fromRGBO(250, 246, 200, 1)];
  List<Color> coloresText = [Color.fromRGBO(173, 66, 60, 1),Color.fromRGBO(117, 110, 8, 1)];

  @override
  void initState(){
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: actividades.length,
        itemBuilder: (context, index) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
          elevation: 3,
          color: colores[index%2],
          child: ListTile(
            title: Text(actividades[index].descripcion, style: const TextStyle(color: Colors.black, fontFamily: 'DidactGothic'),),
            subtitle: Text(actividades[index].fecha_realizacion, style: TextStyle(fontFamily: 'DidactGothic', color: Color.fromRGBO(56, 56, 56, 1)),),
            trailing: Text('${actividades[index].hora_inicio}-${actividades[index].hora_final}',
              style: TextStyle(color: coloresText[index%2], fontFamily: 'Quicksand',),
            ),
          ),
        ),
    );
  }

  _loadData () async{
    List<Actividad> auxActividad = await Operation.actividades2();
    setState((){
      actividades = auxActividad;
    });
  }
}
