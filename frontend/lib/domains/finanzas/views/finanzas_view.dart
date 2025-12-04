import 'package:flutter/material.dart';

import '../../../core/widgets/menu_inferior_widget.dart';
import '../widgets/boton_grande_widget.dart';
import '../widgets/movimiento_card_widget.dart';
import '../widgets/crear_movimientos_widget.dart';

import '../services/finanzas_service.dart';

class FinanzasView extends StatefulWidget {
  const FinanzasView({super.key});

  @override
  State<FinanzasView> createState() => _FinanzasViewState();
}


class _FinanzasViewState extends State<FinanzasView> {

  List<Map<String, dynamic>> listaMovimientos = [];

  final _service = FinanzasService();

  //----------------------------------------------------------------------------

  double get totalGastos {
    return listaMovimientos
        .where((m) => m['esGasto'] == true)
        .fold(0.0, (sum, item) => sum + item['cantidad']);    //fold(valor_inicial, (acumulador, elemento_actual) => operación)
  }

  double get totalIngresos {
    return listaMovimientos
        .where((m) => m['esGasto'] == false)
        .fold(0.0, (sum, item) => sum + item['cantidad']);
  }

  double get totalNeto => totalIngresos - totalGastos;

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _cargarMovimientos();
  }

  //GET
  Future<void> _cargarMovimientos() async {
    final data = await _service.getMovimientos();
    setState(() {
      listaMovimientos = data;
    });
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    DateTime ahora = DateTime.now();
    List<String> meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    int numero_del_mes = ahora.month;
    String nombre_del_mes = meses[numero_del_mes - 1];


    final double totalMovido = totalGastos + totalIngresos;
    final double valorGastoBarra = totalMovido > 0 ? totalGastos / totalMovido : 0.0;
    final double valorIngresoBarra = totalMovido > 0 ? totalIngresos / totalMovido : 0.0;


    return DefaultTabController(length: 3,
        child: MenuInferiorWidget(
          colorMAS: Colors.blueAccent,
          pulsarMAS: () => _abrirVentanaCrear(),

          //********************************************************************

          appBar: AppBar(
            automaticallyImplyLeading: false, //sin flechita
            bottom: const TabBar(
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

                    /*Center(                                                //MES
                      child: Text(
                        '$nombre_del_mes ${ahora.year}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),*/


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


                              Column(                                 //INGRESOS
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Ingresos', style: TextStyle(fontSize: 20)),
                                      Text(
                                          '${totalIngresos.toStringAsFixed(2)}€',
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: valorIngresoBarra,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey.shade300,
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ],
                              ),



                              Column(                                   //GASTOS
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Gastos', style: TextStyle(fontSize: 20)),
                                      Text(
                                          '${totalGastos.toStringAsFixed(2)}€',
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: valorGastoBarra,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey.shade300,
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ],
                              ),

                              const Divider(thickness: 1),
                              Center(
                                child: Text(
                                  'Total: ${totalNeto.toStringAsFixed(2)}€',
                                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),


                    Expanded(                    //CUADRADOS: resumen y categoría
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: BotonGrande(
                              icono: Icons.bar_chart,
                              texto: 'Resumen',
                              color: Colors.purpleAccent,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: BotonGrande(
                              icono: Icons.grid_view_rounded,
                              texto: 'Categorías',
                              color: Colors.orangeAccent,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              //................................................................

              _HistorialMovimientos(
                movimientos: listaMovimientos.where((m) => m['esGasto'] == false).toList(),
              ),

              //................................................................

              _HistorialMovimientos(
                movimientos: listaMovimientos.where((m) => m['esGasto'] == true).toList(),
              ),           //PESTAÑA GASTOS
            ],
          ),
        )
    );
  }

  //----------------------------------------------------------------------------

  void _abrirVentanaCrear() {
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
      await _cargarMovimientos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Movimiento creado con éxito."), duration: Duration(seconds: 1)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar."), duration: Duration(seconds: 2), backgroundColor: Colors.red),
      );
    }
  }

}


//------------------------------------------------------------------------------

class _HistorialMovimientos extends StatelessWidget {
  final List<Map<String, dynamic>> movimientos;

  const _HistorialMovimientos({required this.movimientos});

  @override
  Widget build(BuildContext context) {
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

        return MovimientoCardWidget(
          nombre: movimiento['nombre'],
          cantidad: movimiento['cantidad'],
          fecha: movimiento['fecha'],
          esGasto: movimiento['esGasto'],
        );
      },
    );
  }
}