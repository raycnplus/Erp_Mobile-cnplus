import 'package:flutter/material.dart';
import '../../purchase_team/widget/purchase_team_form.dart';


class PurchaseTeamScreen extends StatelessWidget {
  const PurchaseTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Purchase Team")),
      body: PurchaseTeamScreenCreate(),
    );
  }
}
