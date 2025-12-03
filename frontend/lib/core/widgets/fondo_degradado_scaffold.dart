import 'package:flutter/material.dart';

class FondoDegradadoScaffold extends StatelessWidget {

  final Widget body;
  final PreferredSizeWidget? appBar;

  const FondoDegradadoScaffold({
    super.key,
    required this.body,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //para que al hacer el degradado se la pele lo de la appbar

      appBar: appBar,


      body: Container(
        width: double.infinity,
        height: double.infinity,
        // DEGRADADO
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF42A5F5),
              Color(0xFF7B1FA2),
              Color(0xFFE91E63),
            ],
          ),
        ),


        child: body,
      ),
    );
  }
}