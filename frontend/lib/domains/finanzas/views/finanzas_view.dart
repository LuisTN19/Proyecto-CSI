import 'package:flutter/material.dart';
import 'package:tugestor/core/widgets/menu_inferior_widget.dart';
import 'package:tugestor/domains/finanzas/widgets/crear_movimientos_widget.dart';
import '../widgets/boton_grande_widget.dart';
import '../widgets/movimiento_card_widget.dart';
import '../services/finanzas_service.dart';

class FinanzasView extends StatefulWidget {
  const FinanzasView({super.key});

  @override
  State<FinanzasView> createState() => _FinanzasViewState();
}


class _FinanzasViewState extends State<FinanzasView> {



  final _service = FinanzasService();

  // Lista de movimientos (vacía para cargar desde la API)
  List<Map<String, dynamic>> listaMovimientos = [];

  // 💡 ELIMINADO: No usamos 'bool isLoading = true;'

  @override
  void initState() {
    super.initState();
    _cargarMovimientos(); // Cargamos los datos al iniciar la vista
  }


  // --- MÉTODO DE CARGA DE DATOS ---
  Future<void> _cargarMovimientos() async {
    // 💡 ELIMINADO: No usamos setState(() => isLoading = true);

    final movimientos = await _service.getMovimientos();

    // Solo actualizamos la lista para que se repinte (setState)
    setState(() {
      listaMovimientos = movimientos;
    });
  }


  @override
  Widget build(BuildContext context) {

    DateTime ahora = DateTime.now();
    List<String> meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    int numero_del_mes = ahora.month;
    String nombre_del_mes = meses[numero_del_mes - 1];




    return DefaultTabController(length: 3,
        child: MenuInferiorWidget(
          colorMAS: Colors.blueAccent,
          pulsarMAS: () => _abrirVentanaCrear(),

          //....................................................................
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
          //....................................................................

          //....................................................................
          body: TabBarView(
            children: [

              Padding(                                                          //PESTAÑA INICIO
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Center(
                      child: Text(                                        //MES
                        '$nombre_del_mes ${ahora.year}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),

                    //**********************************

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
                              /*Center(
                                child: Text(                                        //MES
                                  '$nombre_del_mes ${ahora.year}',
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                              ),*/

                              /*Text(
                                '$nombre_del_mes ${ahora.year}',
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                              ),*/

                              Column(                                   //GASTOS
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Gastos', style: TextStyle(fontSize: 20)),
                                      Text('0€', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: 0.0,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey.shade300,
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ],
                              ),

                              Column(                                 //INGRESOS
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Ingresos', style: TextStyle(fontSize: 20)),
                                      Text('0€', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: 0.0,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey.shade300,
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 1),
                              // TOTAL

                              const Center(
                                child: Text(
                                  'Total: 0€',
                                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    //**********************************

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


              _ListaMovimientos(
                movimientos: listaMovimientos.where((m) => m['esGasto'] == false).toList(),
              ),

// ----------------------------------------------------
// 💡 PESTAÑA GASTOS
// ----------------------------------------------------
              _ListaMovimientos(
                movimientos: listaMovimientos.where((m) => m['esGasto'] == true).toList(),
              ),           //PESTAÑA GASTOS
            ],
          ),
          //....................................................................


        )
    );

  }

  void _crearMovimiento(String nombre, double cantidad, String fechaLaravel, bool esGasto) async {
    // Lógica de _crearMovimiento (la que ya tenías, pero ahora recibe fechaLaravel)
    final exito = await _service.postMovimiento(nombre, cantidad, fechaLaravel, esGasto);

    if (exito) {
      await _cargarMovimientos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Movimiento guardado."), duration: Duration(seconds: 1)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar."), duration: Duration(seconds: 2), backgroundColor: Colors.red),
      );
    }
  }


  void _abrirVentanaCrear() {
    showDialog(
      context: context,
      builder: (context) {
        // 👈 CAMBIO: Instanciamos el StatefulWidget personalizado
        return CrearMovimientoWidget(
          onGuardar: _crearMovimiento, // Le pasamos la función que hace la llamada a la API
        );
      },
    );
  }

}


class _ListaMovimientos extends StatelessWidget {
  final List<Map<String, dynamic>> movimientos;

  const _ListaMovimientos({required this.movimientos});

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