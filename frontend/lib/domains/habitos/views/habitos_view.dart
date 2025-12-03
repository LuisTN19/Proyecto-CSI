import 'package:flutter/material.dart';

import '../../../core/widgets/menu_inferior_widget.dart';
import '../widgets/habitos_card_widget.dart';
import '../widgets/crear_habito_widget.dart';

import '../services/habitos_service.dart';



class HabitosView extends StatefulWidget {
  const HabitosView({super.key});

  @override
  State<HabitosView> createState() => _HabitosViewState();
}



class _HabitosViewState extends State<HabitosView> {

  List<Map<String, dynamic>> listaPorHacer = [];
  List<Map<String, dynamic>> listaCompletados = [];

  final _service = HabitosService();

  Set<int> seleccionados = {};
  bool get haySeleccion => seleccionados.isNotEmpty;

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  //GET
  void _cargarDatos() async {
    final data = await _service.getHabitos();
    if (mounted) {
      setState(() {
        listaPorHacer = data.where((h) => h['completado'] == false).toList();
        listaCompletados = data.where((h) => h['completado'] == true).toList();
      });
    }
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
      child: MenuInferiorWidget(

        colorMAS: Colors.red,
        pulsarMAS: haySeleccion ? null : _abrirVentanaCrear,

        //**********************************************************************

        appBar: AppBar(
          automaticallyImplyLeading: false,

          title: haySeleccion
              ? Text("${seleccionados.length} seleccionados", style: const TextStyle(color: Colors.white))
              : null,

          actions: haySeleccion
              ? [
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _borrarSeleccionados),
            IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => setState(() => seleccionados.clear())),
          ]
              : [],

          bottom: haySeleccion
              ? null
              : const TabBar(
            labelColor: Colors.red,
            indicatorColor: Colors.red,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),

            tabs: [
              Tab(text: 'Por Hacer'),
              Tab(text: 'Completados'),
            ],
          ),
        ),

        //**********************************************************************

        body: TabBarView(
          children: [


            ListView.builder(                                                   //POR HACER
              itemCount: listaPorHacer.length,

              itemBuilder: (context, index) {
                final item = listaPorHacer[index];

                return HabitosCardWidget(
                  habito: item['nombre'],
                  esta_completado: false,
                  al_pulsar_check: () => _marcarCheck(item['id'], false),
                  es_seleccionado: seleccionados.contains(item['id']),
                  hay_seleccion_activa: haySeleccion,
                  seleccionar: () => _multiseleccion(item['id']),
                );
              },
            ),

            //..................................................................

            ListView.builder(                                                   //COMPLETADOS
              itemCount: listaCompletados.length,

              itemBuilder: (context, index) {
                final item = listaCompletados[index];

                return HabitosCardWidget(
                  habito: item['nombre'],
                  esta_completado: true,

                  al_pulsar_check: () => _marcarCheck(item['id'], true),
                  es_seleccionado: seleccionados.contains(item['id']),
                  hay_seleccion_activa: haySeleccion,
                  seleccionar: () => _multiseleccion(item['id']),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  void _abrirVentanaCrear() {
    showDialog(
      context: context,
      builder: (context) {

        return CrearHabitoWidget(
          onGuardar: _crearHabito,
        );
      },
    );
  }

  //POST
  void _crearHabito(String nombre) async {
    await _service.postHabito(nombre);
    _cargarDatos();
  }

  //----------------------------------------------------------------------------

  //PUT
  void _marcarCheck(int id, bool estado) async {
    await _service.putHabito(id, estado);
    _cargarDatos();
  }

  //----------------------------------------------------------------------------

  void _multiseleccion(int id) {
    setState(() {
      if (seleccionados.contains(id)) {
        seleccionados.remove(id);
      } else {
        seleccionados.add(id);
      }
    });
  }

  //DELETE
  void _borrarSeleccionados() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Borrar?"),
        content: Text("Se eliminarán ${seleccionados.length} hábitos permanentemente."),

        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),

          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              for (int id in seleccionados) await _service.deleteHabito(id);
              setState(() => seleccionados.clear());
              _cargarDatos();
            },
            child: const Text("Borrar", style: TextStyle(color: Colors.red)),
          ),

        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
}