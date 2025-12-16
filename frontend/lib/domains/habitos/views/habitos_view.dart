import 'package:flutter/material.dart';

import '../../../core/widgets/menu_inferior_widget.dart';
import '../../../core/widgets/seleccion_mixin.dart';
import '../widgets/habitos_card_widget.dart';
import '../widgets/crear_habito_widget.dart';

import '../services/habitos_service.dart';



class HabitosView extends StatefulWidget {
  const HabitosView({super.key});

  @override
  State<HabitosView> createState() => _HabitosViewState();
}



class _HabitosViewState extends State<HabitosView> with SelectionMixin{

  List<Map<String, dynamic>> listaPorHacer = [];
  List<Map<String, dynamic>> listaCompletados = [];

  final _service = HabitosService();


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
        listaPorHacer = data.where((h) => h['esCompletado'] == false).toList();
        listaCompletados = data.where((h) => h['esCompletado'] == true).toList();
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
            IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: limpiarSeleccion),
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
            _construirListaHabitos(listaPorHacer, false),                       // POR HACER

            _construirListaHabitos(listaCompletados, true),                     //COMPLETADOS
          ],
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  Widget _construirListaHabitos(List<Map<String, dynamic>> habitos, bool completado) {
    if (habitos.isEmpty) {
      return const Center(
        child: Text(
            "No hay hábitos en esta categoría.",
            style: TextStyle(color: Colors.grey)
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: habitos.length,

      itemBuilder: (context, index) {
        final habito = habitos[index];
        final id = habito['id'];  // Importante: ID para la multiselección

        return HabitosCardWidget(
          nombre: habito['nombre'],
          esta_completado: completado,


          al_pulsar_check: () {
            _marcarCheck(id, completado);
          },

          // MULTISELECCION
          es_seleccionado: seleccionados.contains(id),
          hay_seleccion_activa: haySeleccion,
          seleccionar: () => multiSeleccion(id),
        );
      },
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
    final exito = await _service.postHabito(nombre);

    if (exito) {
      _cargarDatos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Hábito creado con éxito."),
            duration: Duration(seconds: 1)
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error al guardar."),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red
        ),
      );
    }
  }

  //----------------------------------------------------------------------------

  //PUT
  void _marcarCheck(int id, bool estado) async {

    bool exito = await _service.putHabito(id, estado);

    if (exito) {
      _cargarDatos();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hábito creado con éxito")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al guardar"), backgroundColor: Colors.red));
    }
  }

  //----------------------------------------------------------------------------


  //DELETE
  void _borrarSeleccionados() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("¿Borrar?"),
        content: Text("Se eliminarán ${seleccionados.length} hábitos permanentemente."),

        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),

          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              for (int id in seleccionados) await _service.deleteHabito(id);
              limpiarSeleccion();
              _cargarDatos();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Se ha eliminado correctamente."),
                    duration: Duration(seconds: 1)
                ),
              );
            },
            child: const Text("Borrar", style: TextStyle(color: Colors.red)),
          ),

        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
}