import 'package:flutter/material.dart';

class MovimientoCardWidget extends StatelessWidget {

  final String nombre;
  final double cantidad;
  final String fecha;
  final bool esGasto;

  const MovimientoCardWidget({
    super.key,
    required this.nombre,
    required this.cantidad,
    required this.fecha,
    required this.esGasto,
  });


  // Variables calculadas
  Color get colorMovimiento => esGasto ? Colors.red : Colors.green;
  String get signoMovimiento => esGasto ? "-" : "+";
  IconData get iconoMovimiento => esGasto ? Icons.arrow_upward : Icons.arrow_downward;


  @override
  Widget build(BuildContext context) {


    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),


        // IZQUIERDA: Ícono
        leading: CircleAvatar(
          backgroundColor: colorMovimiento.withOpacity(0.15),
          child: Icon(
            iconoMovimiento,
            color: colorMovimiento,
          ),
        ),


        // CENTRO: Título y Fecha
        title: Text(
          nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(fecha, style: TextStyle(color: Colors.grey.shade600)),


        // DERECHA: Cantidad con signo
        trailing: Text(
          '$signoMovimiento${cantidad.toStringAsFixed(2)}€',
          style: TextStyle(
            color: colorMovimiento,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

