import 'package:flutter/material.dart';

typedef GuardarMovimientoCallback = void Function(String nombre, double cantidad, String fechaLaravel, bool esGasto, );

class CrearMovimientoWidget extends StatefulWidget {
  final GuardarMovimientoCallback onGuardar;

  const CrearMovimientoWidget({
    super.key,
    required this.onGuardar,
  });

  @override
  State<CrearMovimientoWidget> createState() => _CrearMovimientoWidgetState();
}

class _CrearMovimientoWidgetState extends State<CrearMovimientoWidget> {

  String _nombre = "";
  String _cantidadStr = "";
  DateTime _fechaSeleccionada = DateTime.now();
  bool _esGasto = true;

  //Errores
  String? _errorNombre;
  String? _errorCantidad;


  String get _fechaMostrar {                // formato DD/MM/AAAA para mostrar en la interfaz
    return "${_fechaSeleccionada.day.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.month.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.year}";
  }


  String get _fechaLaravel {                // formato YYYY-MM-DD para enviar a Laravel
    return "${_fechaSeleccionada.year}-"
        "${_fechaSeleccionada.month.toString().padLeft(2, '0')}-"
        "${_fechaSeleccionada.day.toString().padLeft(2, '0')}";
  }
  // ------------------------------------

  // SELECCIONAR FECHA
  Future<void> _seleccionarFecha() async {
    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (seleccion != null && seleccion != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = seleccion;
      });
    }
  }

  // ------------------------------------

  // GUARDAR
  void _guardarMovimiento() {
    setState(() {
      _errorNombre = null;
      _errorCantidad = null;
    });
    bool hayError = false;


    if (_nombre.isEmpty) {  //NOMBRE NO VACIO
      setState(() {
        _errorNombre = "Introduce un nombre.";
        hayError = true;
      });
    }

    if (_cantidadStr.isEmpty) { //CANTIDAD NO VACIA
      setState(() {
        _errorCantidad = "Introduce la cantidad.";
        hayError = true;
      });
    }
    if (hayError) return;

    final double? cantidadDouble = double.tryParse(_cantidadStr.replaceAll(',', '.'));  //CANTIDAD SEA NUMÉRICA, (se remplaza además cq coma por puntos)
    if (cantidadDouble == null) {
      setState(() {
        _errorCantidad = "La cantidad debe ser un número.";
      });
    } else {
      widget.onGuardar(_nombre, cantidadDouble, _fechaLaravel, _esGasto);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nuevo Movimiento"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            // GASTO/INGRESO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("Gasto"),
                  selected: _esGasto == true,
                  selectedColor: Colors.red,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _esGasto = true);
                    }
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text("Ingreso"),
                  selected: _esGasto == false,
                  selectedColor: Colors.green,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _esGasto = false);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // NOMBRE
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
                errorText: _errorNombre,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              onChanged: (val) => _nombre = val,
            ),
            const SizedBox(height: 15),

            // CANTIDAD
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Cantidad (€)",
                border: OutlineInputBorder(),
                errorText: _errorCantidad,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              onChanged: (val) => _cantidadStr = val,
            ),
            const SizedBox(height: 15),


            //  FECHA
            InkWell(
              onTap: _seleccionarFecha,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Fecha",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _fechaMostrar, // Usamos el getter
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),

      actions: [
        //Cancelar
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        //Guardar
        ElevatedButton(
          onPressed: _guardarMovimiento,
          child: const Text("Guardar"),
        ),

      ],
    );
  }
}