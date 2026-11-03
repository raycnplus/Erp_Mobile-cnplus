import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_sale_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

class PosReceiptScreen extends StatelessWidget {
  const PosReceiptScreen({super.key});

  void _newTransaction(BuildContext context) {
    context.read<PosSaleController>().startNewTransaction();
    Navigator.of(context).popUntil(
      (r) => r.settings.name == AppRoutes.posTransaction || r.isFirst,
    );
  }

  Future<void> _sendEmail(BuildContext context, PosSaleController sale) async {
    final input = TextEditingController(text: sale.customer?.email ?? '');

    final email = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Send receipt to email', style: GoogleFonts.poppins(fontSize: 16)),
        content: TextField(
          controller: input,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'name@domain.com'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, input.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (email == null || email.isEmpty) return;

    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!valid) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email address')),
        );
      }
      return;
    }

    final error = await sale.sendReceiptEmail(email);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Receipt sent to $email')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Receipt',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: colorTextPrimary,
              fontSize: 20,
            ),
          ),
          elevation: 0.5,
          backgroundColor: colorWhite,
          foregroundColor: colorTextPrimary,
        ),
        body: Consumer<PosSaleController>(
          builder: (context, sale, child) {
            final tx = sale.lastTransaction;

            if (tx == null) {
              return Column(
                children: [
                  const Expanded(
                    child: SessionEmptyState(
                      icon: Icons.receipt_long_outlined,
                      message: 'No transaction to show',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () => _newTransaction(context),
                      child: const Text('Back to POS'),
                    ),
                  ),
                ],
              );
            }

            final color = tx.isPaid ? Colors.green : Colors.orange;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Column(
                        children: [
                          Icon(
                            tx.isPaid ? Icons.check_circle : Icons.hourglass_bottom,
                            size: 64,
                            color: color,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tx.isPaid ? 'Payment Successful' : 'Payment ${tx.status}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      SessionInfoCard(
                        children: [
                          SessionInfoRow(label: 'Store', value: sessionDash(sale.storeName)),
                          SessionInfoRow(label: 'Transaction', value: sessionDash(tx.transactionCode)),
                          SessionInfoRow(label: 'Date', value: sessionDash(tx.transactionDate)),
                          SessionInfoRow(label: 'Customer', value: sessionDash(tx.customerName)),
                          SessionInfoRow(label: 'Payment', value: sessionDash(tx.paymentMethod)),
                        ],
                      ),
                      SessionInfoCard(
                        title: 'Items (${tx.items.length})',
                        children: [
                          for (int i = 0; i < tx.items.length; i++) ...[
                            if (i > 0) const Divider(height: 20, color: colorGreyLight),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.items[i].productName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: colorTextPrimary,
                                        ),
                                      ),
                                      Text(
                                        '${formatPrice(tx.items[i].qty)} × ${sessionMoney(tx.items[i].price)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: colorTextSubtle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  sessionMoney(tx.items[i].subtotal),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      SessionInfoCard(
                        children: [
                          SessionInfoRow(
                            label: 'Total',
                            value: sessionMoney(tx.totalAmount),
                            valueColor: colorPrimary,
                            bold: true,
                          ),
                          SessionInfoRow(label: 'Paid', value: sessionMoney(tx.paidAmount)),
                          SessionInfoRow(label: 'Change', value: sessionMoney(tx.changeAmount)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: colorCard,
                    boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, -2))],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: sale.isSendingReceipt ? null : () => _sendEmail(context, sale),
                              icon: sale.isSendingReceipt
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.email_outlined, size: 18, color: colorPrimary),
                              label: Text(
                                'Send Email',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: colorPrimary,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: colorPrimary),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _newTransaction(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorPrimary,
                                foregroundColor: colorWhite,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                'New Transaction',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}