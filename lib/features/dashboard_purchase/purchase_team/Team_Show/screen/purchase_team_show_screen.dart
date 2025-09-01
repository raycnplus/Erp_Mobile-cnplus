import 'package:flutter/material.dart';
import '../../widget/purchase_team_show.dart';

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