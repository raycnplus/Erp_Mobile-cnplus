import 'package:flutter/material.dart';
import '../widget/purchase_team_show.dart';
import '../../Team_Show/widget/purchase_team_delete.dart';

class PurchaseTeamShowScreen extends StatelessWidget {
  final int teamId;
  final String token;

  const PurchaseTeamShowScreen({
    super.key,
    required this.teamId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Show Purchase Team")),
      body: Column(
        children: [
          Expanded(
            child: PurchaseTeamShowWidget(teamId: teamId),
          ),
          const SizedBox(height: 16),
          DeletePurchaseTeamButton(
            teamId: teamId,
            token: token,
            onDeleted: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}