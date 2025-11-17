import 'package:flutter/material.dart';

class StatutBadge extends StatelessWidget {
  final String statut;

  const StatutBadge({super.key, required this.statut});

  Color _getColor() {
    switch (statut) {
      case 'validée':
        return Colors.blue;
      case 'livrée':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(statut),
      backgroundColor: _getColor(),
      labelStyle: TextStyle(color: _getColor()),
    );
  }
}
