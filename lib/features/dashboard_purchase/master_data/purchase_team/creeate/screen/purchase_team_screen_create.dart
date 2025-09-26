import 'package:flutter/material.dart';
import '../widget/purchase_team_form.dart';

class PurchaseTeamScreenCreate extends StatelessWidget {
  const PurchaseTeamScreenCreate({super.key});

  @override
  Widget build(BuildContext context) {
    print('[DEBUG] PurchaseTeamScreenCreate dibuka');
    return Scaffold(
      appBar: AppBar(title: const Text("Create Purchase Team")),
      body: const PurchaseTeamForm(),
    );
  }
}