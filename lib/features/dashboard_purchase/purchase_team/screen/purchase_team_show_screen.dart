import 'package:flutter/material.dart';
import '../../purchase_team/widget/purchase_team_show.dart';
import '../../purchase_team/widget/purchase_team_delete.dart';

class PurchaseTeamShowScreen extends StatelessWidget {
  final int teamId;

  const PurchaseTeamShowScreen({
    super.key,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Show Purchase Team")),
      body: PurchaseTeamShowWidget(
        teamId: teamId,
      ),
    );
  }
}