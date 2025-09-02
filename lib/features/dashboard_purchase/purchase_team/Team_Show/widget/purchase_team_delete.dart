import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../services/api_base.dart';

class DeletePurchaseTeamButton extends StatelessWidget {
  final int teamId;
  final VoidCallback? onDeleted;

  const DeletePurchaseTeamButton({
    super.key,
    required this.teamId,
    this.onDeleted,
  });

  Future<void> _deleteTeam(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus team ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // Ambil token dari secure storage
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      if (token == null || token.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Token tidak ditemukan. Silakan login ulang."),
            ),
          );
        }
        return;
      }

      final response = await http.delete(
        Uri.parse("${ApiBase.baseUrl}/purchase/purchase-team/$teamId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          onDeleted?.call();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Team berhasil dihapus")),
          );
        }
      } else {
        String errorMsg = "Gagal menghapus team";
        try {
          errorMsg = response.body;
        } catch (_) {}
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMsg)));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
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
