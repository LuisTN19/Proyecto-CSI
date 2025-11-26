import 'package:flutter/material.dart';
import 'habitos_card_widget.dart';
import 'habitos_service.dart';

class HabitosView extends StatefulWidget {
  const HabitosView({super.key});

  @override
  State<HabitosView> createState() => _HabitosViewState();
}


//------------------------------------------------------------------------------


class _HabitosViewState extends State<HabitosView> {

  // --- 1. VARIABLES DINÁMICAS (Se llenan desde Laravel) ---
  List<Map<String, dynamic>> listaPorHacer = [];
  List<Map<String, dynamic>> listaCompletados = [];
  bool cargando = true;

  // --- 2. EL SERVICIO (El cerebro) ---
  final _service = HabitosService();

  // --- 3. CARGA INICIAL ---
  @override
  void initState() {
    super.initState();
    _cargarDatos(); // Pedimos los datos al entrar
  }

  // Función para traer datos de la BD
  void _cargarDatos() async {
    final todos = await _service.getHabitos();

    if (mounted) {
      setState(() {
        // Filtramos: los que tienen completado: false van a una lista, los true a otra
        listaPorHacer = todos.where((h) => h['completado'] == false).toList();
        listaCompletados = todos.where((h) => h['completado'] == true).toList();
        cargando = false;
      });
    }
  }

  // Función del TIC (Mover)
  void _alPulsarHabito(int id, bool estadoActual) async {
    // Llamamos al backend para cambiar el estado
    await _service.toggleCompletado(id, estadoActual);
    _cargarDatos(); // Recargamos para ver el cambio
  }

  // Función AÑADIR
  void _crearNuevoHabito(String nombre) async {
    await _service.agregarHabito(nombre);
    _cargarDatos(); // Recargamos
  }

  // Ventana flotante
  void _abrirVentanaCrear() {
    String nuevoTexto = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Nuevo Hábito", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "Escribe el nombre..."),
                onChanged: (val) => nuevoTexto = val,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (nuevoTexto.isNotEmpty) {
                    _crearNuevoHabito(nuevoTexto);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Guardar"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(

          //....................................................................
          appBar: AppBar(
            automaticallyImplyLeading: false, //sin flechita
            bottom: const TabBar(
                labelColor: Colors.red,
                indicatorColor: Colors.red,
                labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Por Hacer'),
                  Tab(text: 'Completados'),
                ]
            ),
          ),
          //....................................................................


          //....................................................................
          body: TabBarView(
            children: [

              ListView.builder(                                                 //PESTAÑA: Por Hacer
                itemCount: listaPorHacer.length, // Usamos la lista dinámica
                itemBuilder: (context, index) {
                  final item = listaPorHacer[index]; // Cogemos el mapa entero (id, nombre, color...)

                  return HabitosCardWidget(
                    habito: item['nombre'], // Sacamos el nombre
                    esta_completado: false,

                    al_pulsar_check: () {
                      // Pasamos el ID real de la base de datos
                      _alPulsarHabito(item['id'], false);
                    },
                  );
                },
              ),


              ListView.builder(                                                 //PESTAÑA: Completados
                itemCount: listaCompletados.length,
                itemBuilder: (context, index) {
                  final item = listaCompletados[index];

                  return HabitosCardWidget(
                    habito: item['nombre'],
                    esta_completado: true,

                    al_pulsar_check: () {
                      // Pasamos el ID real
                      _alPulsarHabito(item['id'], true);
                    },
                  );
                },
              ),
            ],
          ),
          //....................................................................


          //....................................................................
          floatingActionButton: FloatingActionButton(
            onPressed: _abrirVentanaCrear,
            backgroundColor: Colors.red,
            child: const Icon(Icons.add, color: Colors.white),                  //BOTÓN +
          ),

          //para que se ponga en el centro:
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
         //.....................................................................


          //....................................................................
          bottomNavigationBar: BottomAppBar(

            shape: const CircularNotchedRectangle(), //la muesca

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(                                                     //BOTÓN CASITA
                  icon: const Icon(Icons.home, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(width: 48),

                IconButton(                                                     //BOTÓN PERFIL
                  icon: const Icon(Icons.person_outline, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          //....................................................................

        )
    );
  }
}