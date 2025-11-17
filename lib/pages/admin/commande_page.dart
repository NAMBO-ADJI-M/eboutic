import 'package:eboutic/models/commande_model.dart';
import 'package:eboutic/services/firestore_service.dart';
import 'package:eboutic/widgets/statut_badge.dart';
import 'package:flutter/material.dart';


class CommandesPage extends StatelessWidget {
  final String utilisateurId; // UID de l'utilisateur connecté

  const CommandesPage({super.key, required this.utilisateurId});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService ();

    return Scaffold(
      appBar: AppBar(title: const Text("Mes commandes")),
      body: StreamBuilder<List<Commande >>(
        stream: firestoreService.getCommandes(utilisateurId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune commande trouvée"));
          }

          final commandes = snapshot.data!;
          return ListView.builder(
            itemCount: commandes.length,
            itemBuilder: (context, index) {
              final commande = commandes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text("Commande #${commande.id}"),
                  subtitle: Text(
                    "Total : ${commande.total} FCFA\nDate : ${commande.date.toLocal()}",
                  ),
                  trailing: StatutBadge (statut: commande.statut),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
