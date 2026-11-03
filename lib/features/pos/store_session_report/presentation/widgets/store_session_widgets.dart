import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

String sessionMoney(double v) => 'Rp ${formatPrice(v)}';

String sessionDash(String? v) => (v == null || v.trim().isEmpty) ? '-' : v;

class SessionStatusBadge extends StatelessWidget {
  final String status;
  const SessionStatusBadge({super.key, required this.status});

  Color get _color {
    switch (status.toUpperCase()) {
      case 'OPEN':
      case 'PAID':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
      case 'CANCELED':
      case 'VOID':
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: _color),
      ),
    );
  }
}

class SessionInfoCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SessionInfoCard({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: colorGreyLight),
              const SizedBox(height: 8),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}

class SessionInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const SessionInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? colorTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SessionErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const SessionErrorState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: colorError),
            const SizedBox(height: 16),
            Text(message, style: GoogleFonts.poppins(color: colorError), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const SessionEmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorTextSubtle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}