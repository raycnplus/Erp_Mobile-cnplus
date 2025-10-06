
import 'package:flutter/material.dart';
import '../widget/sales_team_show.dart';
import '../widget/sales_team_delete.dart';

class SalesTeamShowScreen extends StatelessWidget {
  final int teamId;

  const SalesTeamShowScreen({super.key, required this.teamId});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Show Purchase Team")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Widget untuk menampilkan detail tim
          Expanded(child: SalesTeamShowWidget(teamId: teamId)),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DeleteSalesTeamButton(
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