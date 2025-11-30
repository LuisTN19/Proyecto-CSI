import 'package:flutter/material.dart';
import 'package:tugestor/core/widgets/menu_inferior_widget.dart';
import 'boton_grande_widget.dart';
import 'movimiento_card_widget.dart';
import 'finanzas_service.dart';

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

  void _abrirVentanaCrear() {
    String nombre = "";
    String cantidad = "";
    DateTime fechaSeleccionada = DateTime.now();

    // El String que usaremos para guardar y mostrar la fecha formateada
    String fecha = "${fechaSeleccionada.day.toString().padLeft(2, '0')}/"
        "${fechaSeleccionada.month.toString().padLeft(2, '0')}/"
        "${fechaSeleccionada.year}";
    bool esGasto = true; // Por defecto, lo dejamos como Gasto

    // *Opcional: Controladores si quieres resetear o validar más complejo*
    // final TextEditingController nombreController = TextEditingController();
    // final TextEditingController cantidadController = TextEditingController();
    // final TextEditingController fechaController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));


    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Usamos StatefulBuilder para manejar el cambio de 'esGasto'
          builder: (context, setState) {


            Future<void> _seleccionarFecha(BuildContext context) async {
              final DateTime? seleccion = await showDatePicker(
                context: context,
                initialDate: fechaSeleccionada,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );

              if (seleccion != null && seleccion != fechaSeleccionada) {
                // USAMOS EL setState DEL StatefulBuilder
                setState(() {
                  fechaSeleccionada = seleccion;
                  fecha = "${seleccion.day.toString().padLeft(2, '0')}/"
                      "${seleccion.month.toString().padLeft(2, '0')}/"
                      "${seleccion.year}";
                });
              }
            }
            // ----------------------------------------------------



            return AlertDialog(
              title: const Text("Nuevo Movimiento"),
              content: SingleChildScrollView( // Para evitar problemas de desbordamiento en teclados
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // 1. TIPO DE MOVIMIENTO (Gasto/Ingreso)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botón para Gasto
                        ChoiceChip(
                          label: const Text("Gasto"),
                          selected: esGasto == true,
                          selectedColor: Colors.red,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => esGasto = true);
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        // Botón para Ingreso
                        ChoiceChip(
                          label: const Text("Ingreso"),
                          selected: esGasto == false,
                          selectedColor: Colors.green,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => esGasto = false);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),


                    // 2. NOMBRE / DESCRIPCIÓN
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Descripción",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => nombre = val,
                    ),
                    const SizedBox(height: 15),


                    // 3. CANTIDAD
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Cantidad (€)",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => cantidad = val,
                    ),
                    const SizedBox(height: 15),


                    // 4. FECHA (Selector)
                    InkWell( // Usamos InkWell para que sea clickeable
                      onTap: () => _seleccionarFecha(context), // Llama a la función de calendario
                      child: InputDecorator( // Hacemos que parezca un TextField
                        decoration: const InputDecoration(
                          labelText: "Fecha",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          fecha, // Muestra el String de la fecha (ej: "30/11/2025")
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 1. Usamos la variable renombrada 'cantidadStr' para validar si el campo está lleno.
                    if (nombre.isNotEmpty && cantidad.isNotEmpty) {

                      // 2. Renombramos la variable de conversión a 'cantidadDouble' para evitar conflictos
                      // y usamos el 'String' (cantidadStr) para la conversión.
                      final double? cantidadDouble = double.tryParse(cantidad.replaceAll(',', '.'));

                      if (cantidadDouble != null) {
                        // 3. Si la conversión fue exitosa, llamamos a la función con el double.
                        _crearMovimiento(nombre, cantidadDouble, fecha, esGasto);
                        Navigator.pop(context);
                      } else {
                        // Opcional: Mostrar un error si la cantidad no es válida (e.g., "abc")
                        // print("Error: Formato de cantidad inválido.");
                      }

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

  void _crearMovimiento(String nombre, double cantidad, String fecha, bool esGasto) async {
    // 1. Convertir la fecha del formato Flutter (DD/MM/AAAA) al formato Laravel (YYYY-MM-DD)
    // Asumimos que la fecha viene como DD/MM/AAAA (ej. "30/11/2025")
    List<String> partesFecha = fecha.split('/');
    // Se construye como AAAA-MM-DD para la API de Laravel
    final String fechaLaravel = '${partesFecha[2]}-${partesFecha[1].padLeft(2, '0')}-${partesFecha[0].padLeft(2, '0')}';

    // 2. Llamada al servicio POST
    final exito = await _service.postMovimiento(nombre, cantidad, fechaLaravel, esGasto);

    // 3. Manejo de la respuesta
    if (exito) {
      await _cargarMovimientos(); // Si tuvo éxito, recargamos la lista desde la API

      // Opcional: Feedback al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Movimiento guardado."), duration: Duration(seconds: 1)),
      );

    } else {
      // Opcional: Feedback al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar."), duration: Duration(seconds: 2), backgroundColor: Colors.red),
      );
    }
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