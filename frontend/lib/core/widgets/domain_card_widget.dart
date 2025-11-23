import 'package:flutter/material.dart';

class DomainCardWidget extends StatelessWidget {
  final String titulo;
  final Color color;
  final IconData icono;
  final VoidCallback onTap;

  const DomainCardWidget({
    super.key,
    required this.titulo,
    required this.color,
    required this.icono,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}