import 'package:flutter/material.dart';

import '../../../core/widgets/menu_inferior_widget.dart';
import '../../../core/widgets/seleccion_mixin.dart';

import '../widgets/movimiento_card_widget.dart';
import '../widgets/crear_movimientos_widget.dart';

import '../services/finanzas_service.dart';

import 'resumen_view.dart';

class FinanzasView extends StatefulWidget {
  const FinanzasView({super.key});

  @override
  State<FinanzasView> createState() => _FinanzasViewState();
}


class _FinanzasViewState extends State<FinanzasView> with SelectionMixin{

  List<Map<String, dynamic>> listaHistorial = [];  //historial completo

  List<Map<String, dynamic>> listaMensual = [];     // para los meses

  final _service = FinanzasService();


  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  //GET
  Future<void> _cargarDatos() async {
    final historial = await _service.getMovimientos();

    if (mounted) {
      setState(() {
        listaHistorial = historial; // Historial (pestañas)
        listaMensual = historial; // Mes actual (Inicio), le asiganmos el historial entero, y ya posteriormente nos encargaremos nmanualmente de filtrar por mes actual
      });
    }
  }

  //----------------------------------------------------------------------------

  //RECUADRO INICIAL (DATOS DEL MES ACTUAL)
  final int mesActual = DateTime.now().month;
  final int annoActual = DateTime.now().year;

  final List<String> meses = const [
    'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
    'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'
  ];
  late final String nombre_del_mes = meses[mesActual - 1];

  double get totalIngresos {
    return listaMensual
        .where((m) => DateTime.parse(m['fecha']).month == mesActual && DateTime.parse(m['fecha']).year == annoActual) //filtra por mes actual
        .where((m) => m['esGasto'] == false)                                                                           //filtra por ingreso
        .fold(0.0, (sum, item) => sum + item['cantidad']); //fold -> acumular progresivamente la variable sum a partir del valor 0.0
  }

  double get totalGastos {
    return listaMensual
        .where((m) => DateTime.parse(m['fecha']).month == mesActual && DateTime.parse(m['fecha']).year == annoActual) //filtra por mes actual
        .where((m) => m['esGasto'] == true)                                                                           //filtra por gasto
        .fold(0.0, (sum, item) => sum + item['cantidad']); //fold -> acumular progresivamente la variable sum a partir del valor 0.0
  }

  double get totalNeto => totalIngresos - totalGastos;



  double get totalMovido => totalGastos + totalIngresos;
  //final double totalMovido = totalGastos + totalIngresos;

  double get valorGastoBarra {
    return totalMovido > 0 ? totalGastos / totalMovido : 0.0;
  }

  double get valorIngresoBarra {
    return totalMovido > 0 ? totalIngresos / totalMovido : 0.0;
  }

  //funcion para quitar los centimos cuando son 00
  String _quitar00(double m) {
    if (m == m.truncateToDouble()) { // Comprueba si tiene decimales distintos de cero, truncate le corta la parte decimal-> es 5.25 = 5?
      return m.toInt().toString(); // Si la parte decimal es .00, muestra solo la parte entera.
    } else {
      return m.toStringAsFixed(2); // Si hay decimales, muestra dos decimales
    }
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(length: 3,
        child: MenuInferiorWidget(
          colorMAS: Colors.blueAccent,
          pulsarMAS: () => _abrirVentanaCrear(),

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
                labelColor: Colors.blueAccent,
                indicatorColor: Colors.blueAccent,
                labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Inicio'),
                  Tab(text: 'Ingresos'),
                  Tab(text: 'Gastos'),
                ]
            ),
          ),

          //********************************************************************

          body: TabBarView(
            children: [

              Padding(                                                          //PESTAÑA INICIO
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(                                         //RECUADRO
                      flex: 3,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //************************************************
                              Center(                                      //MES
                                child: Text(
                                  '$nombre_del_mes $annoActual',
                                  style: const TextStyle(fontSize:26, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),

                              //************************************************

                              Column(                                 //INGRESOS
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Ingresos', style: TextStyle(fontSize: 20)),
                                      Text(
                                          '${_quitar00(totalIngresos)}€',
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  //Barra
                                  LinearProgressIndicator(value: valorIngresoBarra, minHeight: 10, backgroundColor: Colors.grey.shade300, color: Colors.green, borderRadius: BorderRadius.circular(5),
                                  ),
                                ],
                              ),

                              //************************************************

                              Column(                                   //GASTOS
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Gastos', style: TextStyle(fontSize: 20)),
                                      Text(
                                          '${_quitar00(totalGastos)}€',
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  //Barra
                                  LinearProgressIndicator(value: valorGastoBarra, minHeight: 10, backgroundColor: Colors.grey.shade300, color: Colors.red, borderRadius: BorderRadius.circular(5),
                                  ),
                                ],
                              ),

                              //************************************************

                              const Divider(thickness: 1),

                              Center(                                   //TOTAL
                                child: Text(
                                  'Total: ${_quitar00(totalNeto)}€',
                                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    //----------------------------------------------------------

                    Expanded(                                          //RESUMEN
                      flex: 1,
                      child: SizedBox.expand(
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResumenView(service: _service),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bar_chart, size: 65, color: Colors.black),
                                SizedBox(height: 12),
                                Text(
                                  'Resumen',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              //................................................................

              _construirListaMovimientos(                                         //PESTAÑA INGRESOS
                listaHistorial.where((m) => m['esGasto'] == false).toList(),
              ),

              //................................................................

              _construirListaMovimientos(                                         //PESTAÑAS GASTOS
                listaHistorial.where((m) => m['esGasto'] == true).toList(),
              ),
            ],
          ),
        )
    );
  }

  //----------------------------------------------------------------------------

  Widget _construirListaMovimientos(List<Map<String, dynamic>> movimientos) {   // widget para controlar la lista tanto de gastos como de ingresos, con la movimientos_card
    if (movimientos.isEmpty) {
      return const Center(
        child: Text("No hay movimientos en esta categoría.", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: movimientos.length,

      itemBuilder: (context, index) {
        final movimiento = movimientos[index];
        final id = movimiento['id']; // Importante: ID para la multiselección

        return MovimientoCardWidget(
          nombre: movimiento['nombre'],
          cantidad: movimiento['cantidad'],
          fecha: movimiento['fecha'],
          esGasto: movimiento['esGasto'],

          es_seleccionado: seleccionados.contains(id),
          hay_seleccion_activa: haySeleccion,
          seleccionar: () => multiSeleccion(id),
        );
      },
    );
  }

  //----------------------------------------------------------------------------

  void _abrirVentanaCrear() {   //Ventana -> widget -> post
    showDialog(
      context: context,
      builder: (context) {

        return CrearMovimientoWidget(
          onGuardar: _crearMovimiento,
        );
      },
    );
  }

  //POST
  void _crearMovimiento(String nombre, double cantidad, String fechaLaravel, bool esGasto) async {

    final exito = await _service.postMovimiento(nombre, cantidad, fechaLaravel, esGasto);

    if (exito) {
      await _cargarDatos(); //asíncrona: debe completarse antes de que ell código continue. Obv al crear un nuevo mov tendremos que cargar los datos nuevamente
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Movimiento creado con éxito."), duration: Duration(seconds: 1)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar."), duration: Duration(seconds: 2), backgroundColor: Colors.red),
      );
    }
  }

  //----------------------------------------------------------------------------

  void _borrarSeleccionados() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("¿Borrar?"),
        content: Text("Se eliminarán ${seleccionados.length} movimientos permanentemente."),

        actions: [
          //Cancelar
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("Cancelar")),

          //Borrar
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              for (int id in seleccionados) await _service.deleteMovimiento(id);
              limpiarSeleccion();
              await _cargarDatos();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Se ha eliminado correctamente."), duration: Duration(seconds: 1)),
              );
            },
            child: const Text("Borrar", style: TextStyle(color: Colors.red)),
          ),

        ],
      ),
    );
  }

}