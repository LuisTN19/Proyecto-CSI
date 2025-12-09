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

  String _nuevoNombre = "";
  String? _errorNombre;

  //----------------------------------------------------------------------------

  void _guardarHabito() {
    setState(() {
      _errorNombre = null;
    });

    // 2. Validamos
    if (_nuevoNombre.trim().isEmpty) {
      setState(() {
        _errorNombre = "Introduce el nombre del hábito.";
      });
      return;
    }

    widget.onGuardar(_nuevoNombre);
    Navigator.pop(context);
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: const Text("Nuevo Hábito"),


      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Nombre del hábito",
              border: const OutlineInputBorder(),
              errorText: _errorNombre,
            ),
            onChanged: (val) {
              _nuevoNombre = val;
              if (_errorNombre != null) setState(() => _errorNombre = null);
            },
          ),
        ],
      ),


      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),

        ElevatedButton(
          onPressed: _guardarHabito,
          child: const Text("Guardar"),
        ),
      ],


    );
  }
}