import 'package:flutter/material.dart';


// La función onGuardar va a recibir el título y la fecha en formato YYYY-MM-DD
typedef GuardarEventoCallback = void Function(String titulo, String fechaLaravel);


class CrearEventoDialog extends StatefulWidget {
  final GuardarEventoCallback onGuardar;
  final DateTime? initialDate;

  const CrearEventoDialog({
    super.key,
    required this.onGuardar,
    this.initialDate,
  });

  @override
  State<CrearEventoDialog> createState() => _CrearEventoDialogState();
}



class _CrearEventoDialogState extends State<CrearEventoDialog>
{
  String _nuevoTitulo = "";
  late DateTime _fechaEvento; // Se inicializará en initState

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    // Inicializa la fecha con la que viene de la vista o la fecha actual
    _fechaEvento = widget.initialDate ?? DateTime.now();
  }

  //  GUARDAR Y VALIDAR
  void _guardarEvento() {
    if (_nuevoTitulo.isEmpty) return;

    // 1. Convertir la fecha al formato YYYY-MM-DD para Laravel
    String fechaLaravel = "${_fechaEvento.year}-"
        "${_fechaEvento.month.toString().padLeft(2, '0')}-"
        "${_fechaEvento.day.toString().padLeft(2, '0')}";

    widget.onGuardar(_nuevoTitulo, fechaLaravel);
  }

  //----------------------------------------------------------------------------

  // SELECCIONAR FECHA
  Future<void> _seleccionarFecha() async {
    DateTime? nuevaFecha = await showDatePicker(
      context: context,
      initialDate: _fechaEvento,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (nuevaFecha != null) {
      setState(() {
        _fechaEvento = nuevaFecha;
      });
    }
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: const Text("Nuevo Evento"),


      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            onChanged: (val) => _nuevoTitulo = val,
          ),
          const SizedBox(height: 20),


          Row(
            children: [
              const Text("Fecha: "),
              TextButton(
                onPressed: _seleccionarFecha,
                child: Text(
                  "${_fechaEvento.day}/${_fechaEvento.month}/${_fechaEvento.year}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),


      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _guardarEvento,
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}