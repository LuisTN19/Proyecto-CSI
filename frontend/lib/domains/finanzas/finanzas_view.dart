import 'package:flutter/material.dart';
import 'boton_grande_widget.dart';

class FinanzasView extends StatelessWidget {
  const FinanzasView({super.key});

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
        child: Scaffold(

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
                              color: Colors.blueGrey.shade800,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: BotonGrande(
                              icono: Icons.grid_view_rounded,
                              texto: 'Categorías',
                              color: Colors.blueGrey.shade800,
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


              Center(child: Text("Aquí irá el historial de Ingresos")),         //PESTAÑA INGRESOS
              Center(child: Text("Aquí irá el historial de Gastos")),           //PESTAÑA GASTOS
            ],
          ),
          //....................................................................

          //....................................................................
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("Botón + pulsado en Finanzas");
            },
            backgroundColor: Colors.blueAccent,
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