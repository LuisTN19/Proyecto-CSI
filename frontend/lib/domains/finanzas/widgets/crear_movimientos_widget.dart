import 'package:flutter/material.dart';

// Definición del callback que usaremos para devolver los datos al padre
typedef GuardarMovimientoCallback = void Function(
    String nombre,
    double cantidad,
    String fechaLaravel, // Fecha ya convertida a formato YYYY-MM-DD
    bool esGasto,
    );

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
  // --- VARIABLES DE ESTADO INTERNAS ---
  String _nombre = "";
  String _cantidadStr = "";
  DateTime _fechaSeleccionada = DateTime.now();
  bool _esGasto = true; // Por defecto: Gasto

  // Getter para la fecha en formato DD/MM/AAAA para mostrar en la interfaz
  String get _fechaMostrar {
    return "${_fechaSeleccionada.day.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.month.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.year}";
  }

  // Getter para la fecha en formato YYYY-MM-DD para enviar a Laravel
  String get _fechaLaravel {
    return "${_fechaSeleccionada.year}-"
        "${_fechaSeleccionada.month.toString().padLeft(2, '0')}-"
        "${_fechaSeleccionada.day.toString().padLeft(2, '0')}";
  }
  // ------------------------------------

  // FUNCIÓN PARA SELECCIONAR FECHA
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

  // FUNCIÓN PARA GUARDAR Y VALIDAR
  void _guardarMovimiento() {
    // 1. Validar que los campos no estén vacíos
    if (_nombre.isNotEmpty && _cantidadStr.isNotEmpty) {
      // 2. Intentar convertir la cantidad a double (manejando ',' y '.')
      final double? cantidadDouble = double.tryParse(_cantidadStr.replaceAll(',', '.'));

      if (cantidadDouble != null) {
        // 3. Si la conversión es exitosa, llamar al callback (onGuardar)
        widget.onGuardar(_nombre, cantidadDouble, _fechaLaravel, _esGasto);
        Navigator.pop(context); // Cerrar el diálogo
      }
      // Opcional: Podrías mostrar un error si la cantidad es inválida aquí.
    }
    // Opcional: Podrías mostrar un error si faltan campos aquí.
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nuevo Movimiento"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. TIPO DE MOVIMIENTO (Gasto/Ingreso)
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

            // 2. NOMBRE / DESCRIPCIÓN
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _nombre = val,
            ),
            const SizedBox(height: 15),

            // 3. CANTIDAD
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Cantidad (€)",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _cantidadStr = val,
            ),
            const SizedBox(height: 15),

            // 4. FECHA (Selector)
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _guardarMovimiento, // Llamamos a nuestra función de guardar
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}