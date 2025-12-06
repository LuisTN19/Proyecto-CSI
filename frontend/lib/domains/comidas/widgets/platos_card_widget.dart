import 'package:flutter/material.dart';

class PlatoCardWidget extends StatelessWidget {
  final String nombre;
  final String? imagenUrl;
  final IconData icono;
  final bool esFavorito;
  final double estrellas;

  final VoidCallback onFav;
  final VoidCallback onTap;

  final bool es_seleccionado;
  final bool hay_seleccion_activa;
  final VoidCallback seleccionar;

  const PlatoCardWidget({
    super.key,
    required this.nombre,
    this.imagenUrl,
    required this.icono,
    required this.esFavorito,
    required this.estrellas,

    required this.onFav,
    required this.onTap,

    required this.es_seleccionado,
    required this.hay_seleccion_activa,
    required this.seleccionar,
  });

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final Color colorTexto = Colors.black87;
    final Color colorNaranja = Colors.orange.shade700;

    const double imagenSize = 60;

    return Card(
      color: es_seleccionado ? Colors.blue.shade100 : Colors.orange.shade100,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),

      shape: es_seleccionado
          ? RoundedRectangleBorder(
        side: const BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(12),
      )
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),


      child: InkWell(
        onTap: hay_seleccion_activa ? seleccionar : onTap,

        onLongPress: seleccionar,
        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              ClipRRect(  // IMAGEN O PLACEHOLDER
                borderRadius: BorderRadius.circular(8),
                child: imagenUrl != null && imagenUrl!.isNotEmpty
                    ? Image.network(
                  imagenUrl!,
                  width: imagenSize,
                  height: imagenSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _iconoWidget(),
                )
                    : _iconoWidget(),
              ),

              const SizedBox(width: 20),

              Expanded( // NOMBRE Y Estrellas del plato
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ocupa solo lo necesario
                  crossAxisAlignment: CrossAxisAlignment.start, // Alineado a la izquierda
                  children: [

                    // 1. EL NOMBRE (Igual que antes)
                    Text(
                      nombre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: colorTexto,
                      ),
                      maxLines: 1, // Recomiendo 1 línea para que no choque con las estrellas
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4), // Un pequeño espacio
                    // 2. LAS ESTRELLAS (Llamamos a una funcioncita auxiliar)
                    _buildMiniEstrellas(estrellas),
                  ],
                ),
              ),


              IconButton( // FAV
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  esFavorito ? Icons.favorite : Icons.favorite_border,
                  color: esFavorito ? colorNaranja : colorTexto.withOpacity(0.5),
                  size: 28,
                ),
                onPressed: onFav,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  Widget _iconoWidget() { //widget auxiliar para el icono por si no hay imagen
    final Color colorNaranja = Colors.orange;
    final Color colorTexto = Colors.black87;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: colorTexto.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(icono, color: colorNaranja, size: 30),
      ),
    );
  }

  // Función para pintar estrellas pequeñitas
  Widget _buildMiniEstrellas(double rating) {
    return Row(
      children: List.generate(5, (index) {
        IconData icon = Icons.star_border;

        if (rating >= index + 1) {
          icon = Icons.star;      // Llena
        } else if (rating >= index + 0.5) {
          icon = Icons.star_half; // Media
        }

        return Icon(icon, color: Colors.orange, size: 16); // Tamaño 16 queda fino
      }),
    );
  }
}