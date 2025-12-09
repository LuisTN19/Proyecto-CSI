import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // paquete para convertir el formaro de la fecha q recibimos de laravel en un formato amigable

class MovimientoCardWidget extends StatelessWidget {

  final String nombre;
  final double cantidad;
  final String fecha; // Recibimos el String completo (ej: 2025-11-20T00000000000x)
  final bool esGasto;

  //Multiselección
  final bool es_seleccionado;
  final bool hay_seleccion_activa;
  final VoidCallback seleccionar;

  const MovimientoCardWidget({
    super.key,
    required this.nombre,
    required this.cantidad,
    required this.fecha,
    required this.esGasto,

    required this.es_seleccionado,
    required this.hay_seleccion_activa,
    required this.seleccionar,
  });

  //----------------------------------------------------------------------------

  // VARIABLES
  Color get colorMovimiento => esGasto ? Colors.red : Colors.green;
  String get signoMovimiento => esGasto ? "-" : "+";
  IconData get iconoMovimiento => esGasto ? Icons.arrow_upward : Icons.arrow_downward;

  String get fechaFormateada {//para que salga la fecha bien en formato 'dd/MM/yyyy'
    try {
      // String ISO 8601 de Laravel -> objeto DateTime
      final DateTime dateTime = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy').format(dateTime);

    } catch (e) {
      return fecha;
    }
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {


    return Card(
      //Multiselección----------------------------------------------------------
      color: es_seleccionado ? Colors.blue.shade100 : null,
      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: es_seleccionado
            ? const BorderSide(color: Colors.blue, width: 2)
            : BorderSide.none,
      ),

      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),

        child: InkWell(
          onTap: hay_seleccion_activa
              ? seleccionar
              : () {},
          onLongPress: seleccionar,

          //--------------------------------------------------------------------

          borderRadius: BorderRadius.circular(12),

          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),


            // IZQUIERDA: Icono
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
            subtitle: Text(fechaFormateada, style: TextStyle(color: Colors.grey.shade600)), // Usamos el getter


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
        ),
    );
  }
}

