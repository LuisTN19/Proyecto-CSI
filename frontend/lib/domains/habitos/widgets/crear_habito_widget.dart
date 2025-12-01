import 'package:flutter/material.dart';

class CrearHabitoWidget extends StatelessWidget {
  final void Function(String) onGuardar;

  const CrearHabitoWidget({
    super.key,
    required this.onGuardar,
  });


  @override
  Widget build(BuildContext context) {
    String nuevoTexto = "";

    return AlertDialog(

      title: const Text("Nuevo Hábito"),


      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Escribe el nombre..."),
            onChanged: (val) => nuevoTexto = val,
          ),
        ],
      ),


      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),

        ElevatedButton(
          onPressed: () {
            if (nuevoTexto.isNotEmpty) {
              onGuardar(nuevoTexto);
              Navigator.pop(context);
            }
          },

          child: const Text("Guardar"),
        ),
      ],


    );
  }
}