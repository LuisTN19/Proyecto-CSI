import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';//Paquete del calendario
import 'dart:math'; // Random

import '../../../core/widgets/menu_inferior_widget.dart';
import '../widgets/evento_card_widget.dart';
import '../widgets/crear_evento_widget.dart';

import '../services/agenda_service.dart';



class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}



class _AgendaViewState extends State<AgendaView> {

  CalendarFormat _formato = CalendarFormat.month;
  DateTime _diaActual = DateTime.now();
  DateTime? _diaSeleccionado;

  Map<DateTime, List<String>> _misEventos = {};

  final _service = AgendaService();


  Color _getColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    final data = await _service.getEventos();

    Map<DateTime, List<String>> eventosTransformados = {};

    for (var item in data) {
      // 'YYYY-MM-DD' de Laravel a objeto DateTime (fecha UTC)
      DateTime fechaLaravel = DateTime.parse(item['fecha']).toUtc();

      // Corregimos la fecha a la clave UTC (solo día) para que coincida con TableCalendar
      DateTime fechaClave = DateTime.utc(fechaLaravel.year, fechaLaravel.month, fechaLaravel.day);

      String titulo = item['titulo'];

      if (eventosTransformados[fechaClave] == null) {
        eventosTransformados[fechaClave] = [titulo];
      } else {
        eventosTransformados[fechaClave]!.add(titulo);
      }
    }

    if (mounted) {
      setState(() {
        _misEventos = eventosTransformados;
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

  List<String> _obtenerEventosPorDia(DateTime day) {  //para saber si tiene que pintar el puntito
    final dayKey = DateTime.utc(day.year, day.month, day.day);
    return _misEventos[dayKey] ?? [];
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
    await _service.postEvento(titulo, fechaLaravel);
    _cargarDatos();
  }

  //----------------------------------------------------------------------------

  List<Map<String, dynamic>> _obtenerEventosDelDiaSeleccionado() {
    if (_diaSeleccionado == null) return [];

    final dayKey = DateTime.utc(_diaSeleccionado!.year, _diaSeleccionado!.month, _diaSeleccionado!.day);

    List<String> titulos = _misEventos[dayKey] ?? [];
    if (titulos.isEmpty) return [];

    return titulos.map((titulo) {
      return {
        'titulo': titulo,
        'fechaString': "${_diaSeleccionado!.day}/${_diaSeleccionado!.month}/${_diaSeleccionado!.year}",
        'color': _getColor(),
      };
    }).toList();
  }

  //----------------------------------------------------------------------------

  List<Map<String, dynamic>> _obtenerEventosOrdenados() {
    List<Map<String, dynamic>> listaPlana = [];

    _misEventos.forEach((fecha, titulos) {
      Color colorAsignado = _getColor();
      for (var titulo in titulos) {
        listaPlana.add({
          'titulo': titulo,
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


}