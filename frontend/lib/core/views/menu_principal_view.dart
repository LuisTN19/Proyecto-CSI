import 'package:flutter/material.dart';
import 'package:tugestor/core/widgets/domain_card_widget.dart';

import '../../domains/finanzas/finanzas_view.dart';
import '../../domains/habitos/habitos_view.dart';
import '../../domains/comidas/comidas_view.dart';
import '../../domains/agenda/agenda_view.dart';
import 'perfil_view.dart';


class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Gestor Personal'),                                //TÍTULO
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilView()),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: DomainCardWidget(                                          //FINANZAS
                titulo: 'Finanzas',
                color: Colors.blue.shade800,
                icono: Icons.account_balance_wallet,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FinanzasView()),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: DomainCardWidget(                                          //AGENDA
                titulo: 'Agenda',
                color: Colors.green.shade800,
                icono: Icons.calendar_today,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AgendaView()),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: DomainCardWidget(                                          //COMIDAS
                titulo: 'Comidas',
                color: Colors.orange.shade800,
                icono: Icons.restaurant,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ComidasView()),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child:DomainCardWidget(                                           //HÁBITOS
                titulo: 'Hábitos',
                color: Colors.red.shade800,
                icono: Icons.check_circle_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HabitosView()),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
