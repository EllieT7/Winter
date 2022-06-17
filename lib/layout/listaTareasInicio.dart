import 'package:flutter/material.dart';
import '../clases/operation.dart';
import '../clases/tarea.dart';

class ListTareas extends StatefulWidget {
  const ListTareas({Key? key}) : super(key: key);

  @override
  State<ListTareas> createState() => _ListTareasState();
}

class _ListTareasState extends State<ListTareas> {
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
      shrinkWrap: true,
      itemCount: tareas.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 2),
        child: ListTile(
          leading: Checkbox(
            activeColor: const Color.fromRGBO(169, 151, 196, 1),
            value: getBool(tareas[index].terminada),
            onChanged: (value) {
              setState(() {
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
          title: Text(tareas[index].descripcion, style: const TextStyle(fontFamily: 'DidactGothic')),
            subtitle: Text(tareas[index].fecha_inicio)
        ),
      ),
    );
  }
  _loadData () async{
    List<Tarea> auxTarea = await Operation.tareas2();
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

