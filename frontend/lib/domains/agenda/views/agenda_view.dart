import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';//Paquete del calendario

import '../../../core/widgets/menu_inferior_widget.dart';
import '../../../core/widgets/seleccion_mixin.dart';
import '../widgets/evento_card_widget.dart';
import '../widgets/crear_evento_widget.dart';

import '../services/agenda_service.dart';



class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}



class _AgendaViewState extends State<AgendaView> with SelectionMixin{

  CalendarFormat _formato = CalendarFormat.month;
  DateTime _diaActual = DateTime.now();
  DateTime? _diaSeleccionado;

  Map<DateTime, List<Map<String, dynamic>>> listaEventos = {};

  final _service = AgendaService();

  //----------------------------------------------------------------------------

  Color _getColor(int idEvento) {
    List<Color> colores = [
      Colors.orange,
      Colors.green,
      Colors.pink,
      Colors.blue,
      Colors.red,
      Colors.purple,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepOrange,
      Colors.indigo,
      Colors.brown,
      Colors.teal,
      Colors.blueGrey,
      Colors.deepPurple,
    ];
    return colores[idEvento % colores.length];      //modulo asegura que el resultado siempre está entre el 0 y el total de colores
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    final data = await _service.getEventos();

    Map<DateTime, List<Map<String, dynamic>>> eventosTransformados = {};  //para agrupar los eventos ya con la fecha normaizada de mismo dia

    for (var item in data) {
      // 'YYYY-MM-DD' de Laravel -> objeto DateTime (fecha UTC)
      DateTime fechaLaravel = DateTime.parse(item['fecha']).toUtc();

      // Normalizar la fecha (Quitar horas/minutos/segundos)
      DateTime fechaClave = DateTime.utc(fechaLaravel.year, fechaLaravel.month, fechaLaravel.day);

      //Crear el objeto
      Map<String, dynamic> eventoObjeto = {
        'id': item['id'],
        'titulo': item['titulo']
      };

      // los agrupa por dias
      if (eventosTransformados[fechaClave] == null) {
        eventosTransformados[fechaClave] = [eventoObjeto];
      } else {
        eventosTransformados[fechaClave]!.add(eventoObjeto);
      }
    }

    if (mounted) {
      setState(() {
        listaEventos = eventosTransformados;
      });
    }
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: MenuInferiorWidget(
          colorMAS: Colors.green,
          pulsarMAS: () => _abrirVentanaCrear(context),

          //********************************************************************

          appBar: AppBar(
            automaticallyImplyLeading: false, //sin flechita

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
                labelColor: Colors.green,
                indicatorColor: Colors.green,
                labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Calendario'),
                  Tab(text: 'Eventos'),
                ]
            ),
          ),

          //********************************************************************

          body: TabBarView(
              children: [

                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      TableCalendar(                                            //CALENDARIO
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _diaActual,
                        calendarFormat: _formato,

                        selectedDayPredicate: (day) {                 //detector
                          return isSameDay(_diaSeleccionado, day);
                        },

                        onDaySelected: (selectedDay, focusedDay) {  //capturador
                          setState(() {
                            _diaSeleccionado = DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
                            _diaActual = focusedDay;
                          });
                        },

                        onFormatChanged: (format) {
                          setState(() {
                            _formato = format;
                          });
                        },

                          eventLoader: _obtenerEventosPorDia,           //puntito
                          calendarStyle: const CalendarStyle(
                            markerDecoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ),



                      Builder(                                                  //EVENTOS POR DIA
                        builder: (context) {
                          final eventosDelDia = _obtenerEventosDelDiaSeleccionado();

                          if (_diaSeleccionado == null || eventosDelDia.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(left: 16.0, bottom: 16.0),

                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Padding(
                                padding: EdgeInsets.only(left: 16.0, top: 10.0, bottom: 5.0),
                                child: Text("Eventos del Día:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),


                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: eventosDelDia.length,
                                itemBuilder: (context, index) {
                                  final evento = eventosDelDia[index];
                                  return EventoCardWidget(
                                    titulo: evento['titulo'],
                                    fecha: evento['fechaString'],
                                    colorFondo: evento['color'],

                                    es_seleccionado: seleccionados.contains(evento['id']),
                                    hay_seleccion_activa: haySeleccion,
                                    seleccionar: () => multiSeleccion(evento['id']),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                //..............................................................

                Builder(                                                        //EVENTOS
                    builder: (context) {
                      final listaEventos = _obtenerEventosOrdenados();

                      return ListView.builder(
                        itemCount: listaEventos.length,
                        itemBuilder: (context, index) {
                          final evento = listaEventos[index];

                          return EventoCardWidget(
                            titulo: evento['titulo'],
                            fecha: evento['fechaString'],
                            colorFondo: evento['color'],

                            es_seleccionado: seleccionados.contains(evento['id']),
                            hay_seleccion_activa: haySeleccion,
                            seleccionar: () => multiSeleccion(evento['id']),
                          );
                        },
                      );
                    }
                ),
              ]
          ),

          //********************************************************************

        )
    );
  }

  //----------------------------------------------------------------------------

  List _obtenerEventosPorDia(DateTime day) {  //para saber si tiene que pintar el puntito
    final dayKey = DateTime.utc(day.year, day.month, day.day);
    return listaEventos[dayKey] ?? [];
  }

  //----------------------------------------------------------------------------

  List<Map<String, dynamic>> _obtenerEventosDelDiaSeleccionado() {
    if (_diaSeleccionado == null) return [];

    final dayKey = DateTime.utc(_diaSeleccionado!.year, _diaSeleccionado!.month, _diaSeleccionado!.day);

    List<Map<String, dynamic>> eventosDelDia = listaEventos[dayKey] ?? [];

    if (eventosDelDia.isEmpty) return [];

    return eventosDelDia.map((evento) {
      return {
        'id': evento['id'],
        'titulo': evento['titulo'],
        'fechaString': "${_diaSeleccionado!.day}/${_diaSeleccionado!.month}/${_diaSeleccionado!.year}",
        'color': _getColor(evento['id']),
      };
    }).toList();
  }

  //----------------------------------------------------------------------------

  List<Map<String, dynamic>> _obtenerEventosOrdenados() {
    List<Map<String, dynamic>> listaPlana = [];

    listaEventos.forEach((fecha, eventos) {

      for (var evento in eventos) {

        Color colorAsignado = _getColor(evento['id']);

        listaPlana.add({
          'id': evento['id'],
          'titulo': evento['titulo'],
          'fecha': fecha,
          'fechaString': "${fecha.day}/${fecha.month}/${fecha.year}",
          'color': colorAsignado,
        });
      }
    });

    listaPlana.sort((a, b) {
      DateTime fechaA = a['fecha'];
      DateTime fechaB = b['fecha'];
      return fechaA.compareTo(fechaB);
    });

    return listaPlana;
  }

  //----------------------------------------------------------------------------

  void _abrirVentanaCrear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CrearEventoDialog(
          onGuardar: _crearEvento,
          initialDate: _diaSeleccionado, //para q salga del tiron el dia q tiene en la ventana
        );
      },
    );
  }

  //POST
  void _crearEvento(String titulo, String fechaLaravel) async {
    final exito = await _service.postEvento(titulo, fechaLaravel);

    if (exito) {
      _cargarDatos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Evento creado con éxito."),
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

//DELETE
  void _borrarSeleccionados() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("¿Borrar?"),
        content: Text("Se eliminarán ${seleccionados.length} eventos permanentemente."),

        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),

          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              for (int id in seleccionados) await _service.deleteEvento(id);
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

}