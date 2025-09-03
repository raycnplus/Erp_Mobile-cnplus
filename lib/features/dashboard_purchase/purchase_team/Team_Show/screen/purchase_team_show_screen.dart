
import 'package:flutter/material.dart';
import '../widget/purchase_team_show.dart';
import '../../Team_Show/widget/purchase_team_delete.dart';

class PurchaseTeamShowScreen extends StatelessWidget {
  final int teamId;

  const PurchaseTeamShowScreen({super.key, required this.teamId});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Show Purchase Team")),
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