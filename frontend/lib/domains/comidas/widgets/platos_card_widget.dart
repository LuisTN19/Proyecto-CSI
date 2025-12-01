import 'package:flutter/material.dart';

class PlatoCardWidget extends StatelessWidget {

  final String nombre;
  final bool es_favorito;

  final VoidCallback onTap;
  final VoidCallback onFavoritoPressed;

  const PlatoCardWidget({
    super.key,
    required this.nombre,
    this.es_favorito = false,
    required this.onTap,
    required this.onFavoritoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),

      child: InkWell( //detectar click en toda la card
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [


              Expanded(
                child: Text(
                  nombre,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),


              IconButton(
                icon: Icon(
                  es_favorito ? Icons.favorite : Icons.favorite_border,
                  color: Colors.orange,
                ),
                onPressed: onFavoritoPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}