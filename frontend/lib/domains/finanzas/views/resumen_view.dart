import 'package:flutter/material.dart';
import '../services/finanzas_service.dart';

class ResumenView extends StatefulWidget {
  final FinanzasService service;

  const ResumenView({super.key, required this.service});

  @override
  State<ResumenView> createState() => _ResumenViewState();
}

class _ResumenViewState extends State<ResumenView> {
  List<Map<String, dynamic>> _resumen = [];     //los datos vienen como mes, año, ingresos, gastos, total
  bool _isLoading = true;

  final List<String> _nombresMeses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

  @override
  void initState() {
    super.initState();
    _cargarResumen();
  }

  Future<void> _cargarResumen() async {
    final data = await widget.service.getResumenMensual();
    setState(() {
      _resumen = data;
      _isLoading = false;
    });
  }

  //FUNCION PARA QUITAR EL .00
  String _formatoMoneda(double cantidad) {
    if ((cantidad * 100) % 100 == 0) {
      return cantidad.toInt().toString();
    } else {
      return cantidad.toStringAsFixed(2);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Mensual'),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _resumen.isEmpty
          ? const Center(child: Text("No hay datos de meses anteriores."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _resumen.length,

        itemBuilder: (context, index) {
          final item = _resumen[index];


          final double ingresos = double.tryParse(item['total_ingresos'].toString()) ?? 0.0;
          final double gastos = double.tryParse(item['total_gastos'].toString()) ?? 0.0;

          final double totalNeto = ingresos - gastos;

          final String nombreMes = _nombresMeses[item['mes'] - 1];
          final int anno = item['anno'];

          final Color colorTotal = totalNeto > 0
              ? Colors.green
              : totalNeto < 0
              ? Colors.red
              : Colors.white;

          final String signoNeto = totalNeto > 0
              ? '+'
              : totalNeto < 0
              ? '-'
              : '';


          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(

              // Mes y Año
              title: Text(
                '$nombreMes $anno',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              // Ingresos/Gastos
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingresos: ${_formatoMoneda(ingresos)}€'),
                  Text('Gastos: ${_formatoMoneda(gastos)}€'),
                ],
              ),

              // Total
              trailing: Text(
                '$signoNeto${_formatoMoneda(totalNeto.abs())}€',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                  color: colorTotal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}