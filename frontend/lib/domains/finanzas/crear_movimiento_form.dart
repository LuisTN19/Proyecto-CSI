import 'package:flutter/material.dart';
import 'finanzas_service.dart';

class CrearMovimientoForm extends StatefulWidget {
  final VoidCallback onMovimientoCreado;

  const CrearMovimientoForm({super.key, required this.onMovimientoCreado});

  @override
  State<CrearMovimientoForm> createState() => _CrearMovimientoFormState();
}

class _CrearMovimientoFormState extends State<CrearMovimientoForm> {
  final _formKey = GlobalKey<FormState>();
  final _service = FinanzasService();

  // --- ESTADO ESENCIAL ---
  String _nombre = '';
  double? _cantidad;
  DateTime _fecha = DateTime.now();
  bool _esGasto = true; // true = Gasto, false = Ingreso
  // ----------------------

  // LÓGICA DE GUARDADO
  void _guardarMovimiento() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final exito = await _service.postMovimiento(
      nombre: _nombre,
      cantidad: _cantidad!,
      esGasto: _esGasto,
      fecha: _fecha.toIso8601String().substring(0, 10),
      categoriaId: null, // IGNORAMOS CATEGORÍA
    );

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (exito) {
        widget.onMovimientoCreado();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al crear.')));
      }
    }
  }

  // WIDGETS AUXILIARES
  Widget _buildDatePicker() => InkWell(
    onTap: () async {
      final picked = await showDatePicker(context: context, initialDate: _fecha, firstDate: DateTime(2000), lastDate: DateTime(2101));
      if (picked != null) setState(() => _fecha = picked);
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Fecha:', style: TextStyle(fontSize: 16)),
        Text('${_fecha.day}/${_fecha.month}/${_fecha.year}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ]),
    ),
  );

  Widget _buildToggle() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(_esGasto ? 'Tipo: GASTO' : 'Tipo: INGRESO', style: TextStyle(color: _esGasto ? Colors.red : Colors.green)),
      Switch(value: _esGasto, onChanged: (v) => setState(() => _esGasto = v), activeColor: Colors.red),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(child: Text('NUEVO MOVIMIENTO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            const SizedBox(height: 20),

            // 1. NOMBRE
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => (v == null || v.isEmpty) ? 'Requerido.' : null,
              onSaved: (v) => _nombre = v!,
            ),
            const SizedBox(height: 10),

            // 2. CANTIDAD
            TextFormField(
              decoration: const InputDecoration(labelText: 'Cantidad (€)'),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || double.tryParse(v) == null || double.parse(v) <= 0) ? 'Cantidad > 0.' : null,
              onSaved: (v) => _cantidad = double.parse(v!),
            ),
            const SizedBox(height: 20),

            // 3. TIPO (GASTO / INGRESO)
            _buildToggle(),
            const Divider(),

            // 4. FECHA
            _buildDatePicker(),
            const Divider(),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: _guardarMovimiento, child: const Text('GUARDAR')),
          ],
        ),
      ),
    );
  }
}