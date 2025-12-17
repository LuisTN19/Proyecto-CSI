import 'package:flutter/material.dart';

class CrearHabitoWidget extends StatefulWidget {
  final void Function(String) onGuardar;

  const CrearHabitoWidget({
    super.key,
    required this.onGuardar,
  });

  @override
  State<CrearHabitoWidget> createState() => _CrearHabitoWidgetState();
}

class _CrearHabitoWidgetState extends State<CrearHabitoWidget> {

  String _nombre = "";

  String? _errorNombre;


  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: const Text("Nuevo Hábito"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,  //abrir teclado
            decoration: InputDecoration(
              labelText: "Nombre del hábito",
              border: const OutlineInputBorder(),
              errorText: _errorNombre,
            ),
            onChanged: (val) {
              _nombre = val;
              if (_errorNombre != null) setState(() => _errorNombre = null);
            },
          ),
        ],
      ),

      actions: [
        //Cancelar
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),

        //Guardar
        ElevatedButton(
          onPressed: _guardarHabito,
          child: const Text("Guardar"),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------

  void _guardarHabito() {
    setState(() {
      _errorNombre = null;
    });

    if (_nombre.trim().isEmpty) {  //si está vacío ->error
      setState(() {
        _errorNombre = "Introduce el nombre del hábito.";
      });
      return;
    }

    widget.onGuardar(_nombre);
    Navigator.pop(context);
  }
}