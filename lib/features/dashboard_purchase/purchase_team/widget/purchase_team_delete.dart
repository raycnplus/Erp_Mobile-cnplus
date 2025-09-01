import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeletePurchaseTeamButton extends StatelessWidget {
  final int teamId;
  final String token;
  final VoidCallback? onDeleted;

  const DeletePurchaseTeamButton({
    super.key,
    required this.teamId,
    required this.token,
    this.onDeleted,
  });

  Future<void> _deleteTeam(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus team ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(
        Uri.parse("https://erp.sorlem.com/api/purchase/purchase-team/"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Team berhasil dihapus")),
          );
          onDeleted?.call();
        }
      } else {
        throw Exception("Gagal menghapus team");
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.delete),
      label: const Text("Hapus"),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      onPressed: () => _deleteTeam(context),
    );
  }
}