import 'package:flutter/material.dart';
import '../../core/widgets/menu_inferior_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'evento_card_widget.dart';
import 'dart:math'; // Necesario para el "Random"
import 'agenda_service.dart';
class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {

  CalendarFormat _formato = CalendarFormat.month;
  DateTime _diaEnFoco = DateTime.now();
  DateTime? _diaSeleccionado;

  Map<DateTime, List<String>> _misEventos = {};

  final _service = AgendaService();

  Color _getColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }


  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  // 💡 FUNCIÓN DE CARGA: Pide los eventos a Laravel y actualiza la lista local
  void _cargarDatos() async {
    // 1. Llama al servicio para obtener los eventos (Map<String, dynamic>)
    final data = await _service.getEventos();

    // 2. Transforma la lista de Map<String, dynamic> en el Map<DateTime, List<String>> que usa tu vista
    Map<DateTime, List<String>> eventosTransformados = {};

    for (var item in data) {
      // Convertimos el String 'YYYY-MM-DD' de Laravel a objeto DateTime (fecha UTC)
      DateTime fechaLaravel = DateTime.parse(item['fecha']).toUtc();

      // Corregimos la fecha a la clave UTC (solo día) para que coincida con TableCalendar
      DateTime fechaClave = DateTime.utc(fechaLaravel.year, fechaLaravel.month, fechaLaravel.day);

      String titulo = item['titulo'];

      // Rellena el mapa
      if (eventosTransformados[fechaClave] == null) {
        eventosTransformados[fechaClave] = [titulo];
      } else {
        eventosTransformados[fechaClave]!.add(titulo);
      }
    }

    // 3. Actualiza el estado si el widget sigue montado
    if (mounted) {
      setState(() {
        _misEventos = eventosTransformados;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: MenuInferiorWidget(
          colorMAS: Colors.green,
          pulsarMAS: () => _abrirVentanaCrear(context),

          //....................................................................
          appBar: AppBar(
            automaticallyImplyLeading: false, //sin flechita
            bottom: const TabBar(
                labelColor: Colors.green,
                indicatorColor: Colors.green,
                labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Calendario'),
                  Tab(text: 'Eventos'),
                ]
            ),
          ),
          //....................................................................


          //....................................................................
          body: TabBarView(
              children: [

                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _diaEnFoco,
                  calendarFormat: _formato,

                  selectedDayPredicate: (day) {
                    return isSameDay(_diaSeleccionado, day);
                  },

                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      // CORRECCIÓN: Normalizamos la fecha seleccionada a UTC para que coincida con la que guardamos
                      _diaSeleccionado = DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
                      _diaEnFoco = focusedDay;
                    });
                  },

                  onFormatChanged: (format) {
                    setState(() {
                      _formato = format;
                    });
                  },
                ),



                Builder( // Usamos Builder para crear un scope donde declarar 'listaEventos'
                    builder: (context) {
                      final listaEventos = _obtenerEventosOrdenados(); // 💡 SOLO una llamada

                      return ListView.builder(
                        itemCount: listaEventos.length, // Usamos la variable
                        itemBuilder: (context, index) {
                          final evento = listaEventos[index]; // Acceso directo

                          return EventoCardWidget(
                            titulo: evento['titulo'],
                            fecha: evento['fechaString'],
                            colorFondo: evento['color'],
                          );
                        },
                      );
                    }
                ),
              ]
          ),
          //....................................................................


        )
    );
  }

  void _abrirVentanaCrear(BuildContext context) {
    DateTime fechaEvento = _diaSeleccionado ?? DateTime.now();
    String nuevoTitulo = ""; // 💡 Variable local para el TextField

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Nuevo Evento"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    // ❌ Eliminamos la propiedad 'controller'
                    autofocus: true,
                    decoration: const InputDecoration(hintText: "Ej: Cita dentista"),
                    onChanged: (val) => nuevoTitulo = val, // 💡 Capturamos el texto en la variable local
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("Fecha: "),
                      TextButton(
                        child: Text(
                          "${fechaEvento.day}/${fechaEvento.month}/${fechaEvento.year}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          DateTime? nuevaFecha = await showDatePicker(
                            context: context,
                            initialDate: fechaEvento,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );

                          if (nuevaFecha != null) {
                            setDialogState(() {
                              fechaEvento = nuevaFecha;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async { // 💡 CAMBIO 1: Hacemos la función ASYNC
                    // 💡 Usamos la variable local 'nuevoTitulo'
                    if (nuevoTitulo.isEmpty) return;

                    // 1. Normalizamos la fecha a UTC para el envío a Laravel
                    // La fecha debe ser enviada como string 'YYYY-MM-DD' a Laravel
                    String fechaString = "${fechaEvento.year}-${fechaEvento.month.toString().padLeft(2, '0')}-${fechaEvento.day.toString().padLeft(2, '0')}";

                    // 2. 💡 CAMBIO 2: Llamamos al servicio (POST)
                    bool exito = await _service.postEvento(nuevoTitulo, fechaString);

                    Navigator.pop(context); // Cerramos el diálogo inmediatamente

                    if (exito) {
                      // 3. 💡 CAMBIO 3: Si tuvo éxito, recargamos la lista desde Laravel
                      _cargarDatos();

                      // Opcional: Mostrar mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Evento guardado con éxito."), duration: Duration(seconds: 1)),
                      );
                    } else {
                      // Opcional: Mostrar mensaje de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Error al guardar el evento."), duration: Duration(seconds: 2), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _obtenerEventosOrdenados() {
    List<Map<String, dynamic>> listaPlana = [];

    _misEventos.forEach((fecha, titulos) {
      Color colorAsignado = _getColor(); // Generamos un color por grupo de eventos del mismo día
      for (var titulo in titulos) {
        listaPlana.add({
          'titulo': titulo,
          'fecha': fecha,
          'fechaString': "${fecha.day}/${fecha.month}/${fecha.year}",
          'color': colorAsignado, // 💡 Guardamos el color aquí
        });
      }
    });

    // 2. Ordenamos la lista por fecha (de más cercana a más lejana)
    listaPlana.sort((a, b) {
      DateTime fechaA = a['fecha'];
      DateTime fechaB = b['fecha'];
      return fechaA.compareTo(fechaB);
    });

    return listaPlana;
  }

}