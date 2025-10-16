import 'package:flutter/material.dart';
import '../widget/purchase_team_show.dart';
import '../widget/purchase_team_delete.dart';
import '../../update/screen/purchase_team_update_screen.dart'; // Add this import

class PurchaseTeamShowScreen extends StatelessWidget {
  final int teamId;

  const PurchaseTeamShowScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Purchase Team"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PurchaseTeamUpdateScreen(id: teamId),
                ),
              );

              // Refresh the show screen if update was successful
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Widget untuk menampilkan detail tim
          Expanded(child: PurchaseTeamShowWidget(teamId: teamId)),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DeletePurchaseTeamButton(
              teamId: teamId,
              onDeleted: () {
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
