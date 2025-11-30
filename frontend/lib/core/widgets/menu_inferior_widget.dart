import 'package:flutter/material.dart';

import '../views/perfil_view.dart';


class MenuInferiorWidget extends StatelessWidget {

  final Widget body;
  final PreferredSizeWidget? appBar;

  final VoidCallback? pulsarMAS;
  final Color colorMAS;

  const MenuInferiorWidget({
    super.key,
    required this.body,
    this.appBar,
    this.pulsarMAS,
    this.colorMAS = Colors.grey, //color por defecto por si se nos olvida
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,

      //------------------------------------------------------------------------  BOTÓN +
      floatingActionButton: pulsarMAS != null
          ? FloatingActionButton(
        onPressed: pulsarMAS,
        backgroundColor: colorMAS,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      //------------------------------------------------------------------------
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            IconButton(
              icon: const Icon(Icons.home, size: 30, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),

            const SizedBox(width: 48),

            IconButton(
              icon: const Icon(Icons.person_outline, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}