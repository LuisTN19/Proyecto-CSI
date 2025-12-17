import 'package:flutter/material.dart';


// onGuardar recibe el título y la fecha en formato YYYY-MM-DD
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
  String _titulo = "";
  late DateTime _fechaEvento; // Se inicializará en initState

  String? _errorTitulo;


  @override
  void initState() {
    super.initState();
    _fechaEvento = widget.initialDate ?? DateTime.now(); // Inicializar la fecha con la que viene de la vista o la fecha actual
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
            decoration: InputDecoration(
              labelText: "Título del evento",
              border: const OutlineInputBorder(),
              errorText: _errorTitulo,
            ),
            onChanged: (val) {
              _titulo = val;

              if (_errorTitulo != null) setState(() => _errorTitulo = null);
            },
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

  //----------------------------------------------------------------------------

  void _guardarEvento() {
    setState(() {
      _errorTitulo = null;
    });

    if (_titulo.trim().isEmpty) {
      setState(() {
        _errorTitulo = "Introduce el título del evento.";
      });
      return;
    }

    //Convertir la fecha al formato YYYY-MM-DD para Laravel
    String fechaLaravel = "${_fechaEvento.year}-"
        "${_fechaEvento.month.toString().padLeft(2, '0')}-"
        "${_fechaEvento.day.toString().padLeft(2, '0')}";

    widget.onGuardar(_titulo, fechaLaravel);
    Navigator.pop(context);
  }
}