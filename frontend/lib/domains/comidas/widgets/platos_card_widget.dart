import 'package:flutter/material.dart';

class PlatoCardWidget extends StatelessWidget {
  final String nombre;
  final String? imagenUrl; // URL de la imagen (opcional)
  final IconData placeholderIcon; // Ícono de reserva si no hay imagen
  final bool esFavorito;
  final VoidCallback? onToggleFavorite;
  final VoidCallback onTap;

  // ❌ Eliminamos calificacion
  // final int calificacion;

  const PlatoCardWidget({
    super.key,
    required this.nombre,
    this.imagenUrl,
    required this.placeholderIcon,
    required this.esFavorito,
    this.onToggleFavorite,
    required this.onTap,
  });

  // Widget auxiliar para el placeholder si no hay imagen
  Widget _buildPlaceholder() {
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
        child: Icon(placeholderIcon, color: colorNaranja, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Colores
    final Color colorFondoTarjeta = Colors.orange.shade100;
    final Color colorTexto = Colors.black87;
    final Color colorNaranja = Colors.orange.shade700;

    const double imagenSize = 60;

    return Card(
      color: colorFondoTarjeta,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),

        // Padding aumentado para dar espacio
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // 1. IMAGEN O PLACEHOLDER
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imagenUrl != null && imagenUrl!.isNotEmpty
                    ? Image.network(
                  imagenUrl!,
                  width: imagenSize,
                  height: imagenSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                )
                    : _buildPlaceholder(),
              ),

              const SizedBox(width: 20),

              // 2. NOMBRE DEL PLATO
              Expanded(
                child: Text(
                  nombre,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colorTexto,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 3. CORAZÓN DE FAVORITO
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  esFavorito ? Icons.favorite : Icons.favorite_border,
                  color: esFavorito ? colorNaranja : colorTexto.withOpacity(0.5),
                  size: 28,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}