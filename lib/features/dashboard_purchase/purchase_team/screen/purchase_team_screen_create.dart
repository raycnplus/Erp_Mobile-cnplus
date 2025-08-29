import 'package:flutter/material.dart';
import '../../purchase_team/widget/purchase_team_form.dart';

class PurchaseTeamScreenCreate extends StatelessWidget {
  const PurchaseTeamScreenCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Purchase Team")),
      body: const PurchaseTeamForm(),
    );
  }
}