import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // paquete para convertir el formaro d ela fecha q recibimos de laravel en un formato amigable

class MovimientoCardWidget extends StatelessWidget {

  final String nombre;
  final double cantidad;
  final String fecha; // Recibimos el String completo (ej: 2025-11-20T00000000000x)
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

  String get fechaFormateada {//para que salga la fecha bien en formato 'dd/MM/yyyy'
    try {
      // 1. Convertir el String ISO 8601 de Laravel a objeto DateTime
      final DateTime dateTime = DateTime.parse(fecha);

      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return fecha;
    }
  }

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
        subtitle: Text(fechaFormateada, style: TextStyle(color: Colors.grey.shade600)), // 💡 USAMOS EL GETTER


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

