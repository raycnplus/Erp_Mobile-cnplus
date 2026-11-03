import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_sale_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_session_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

class PosPaymentScreen extends StatefulWidget {
  const PosPaymentScreen({super.key});

  @override
  State<PosPaymentScreen> createState() => _PosPaymentScreenState();
}

class _PosPaymentScreenState extends State<PosPaymentScreen> {
  final TextEditingController _received = TextEditingController();

  @override
  void dispose() {
    _received.dispose();
    super.dispose();
  }

  double get _paid => parsePrice(_received.text);

  String _label(String m) => switch (m) {
        'CASH' => 'Cash',
        'QRIS' => 'QRIS',
        'VA' => 'Virtual Account',
        _ => m,
      };

  IconData _icon(String m) => switch (m) {
        'CASH' => Icons.payments_outlined,
        'QRIS' => Icons.qr_code_2,
        'VA' => Icons.account_balance_outlined,
        _ => Icons.credit_card,
      };

  List<double> _quickAmounts(double total) {
    double ceilTo(double v, double step) => (v / step).ceil() * step;
    final set = <double>{
      total,
      ceilTo(total, 10000),
      ceilTo(total, 50000),
      ceilTo(total, 100000),
    };
    return (set.toList()..sort()).take(4).toList();
  }

  void _goReceipt() {
    context.read<PosSessionController>().refreshSession();
    Navigator.pushReplacementNamed(context, AppRoutes.posTransactionReceipt);
  }

  Future<void> _openUrl(String url) async {
    final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot open the payment page')),
      );
    }
  }

  Future<void> _payCash(PosSaleController sale) async {
    final ok = await sale.payCash(_paid);
    if (ok && mounted) _goReceipt();
  }

  Future<void> _startOnline(PosSaleController sale) async {
    final p = await sale.startOnlinePayment();
    if (p != null) await _openUrl(p.redirectUrl);
  }

  Future<void> _confirmOnline(PosSaleController sale) async {
    final ok = await sale.confirmOnlinePayment();
    if (ok && mounted) _goReceipt();
  }

  Widget _amountDue(PosSaleController sale) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorPrimary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorPrimary.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text('Amount due', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
            const SizedBox(height: 4),
            Text(
              sessionMoney(sale.cartTotal),
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: colorPrimary,
              ),
            ),
          ],
        ),
      );

  Widget _methodTiles(PosSaleController sale) {
    final locked = sale.midtrans != null || sale.isProcessing || sale.isPolling;

    return Column(
      children: [
        for (final m in sale.paymentMethods)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: locked ? null : () => sale.selectPaymentMethod(m),
              borderRadius: BorderRadius.circular(12),
              child: Opacity(
                opacity: locked && sale.paymentMethod != m ? 0.5 : 1,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sale.paymentMethod == m ? colorPrimary : colorGreyLight,
                      width: sale.paymentMethod == m ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(_icon(m), color: sale.paymentMethod == m ? colorPrimary : colorGrey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _label(m),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorTextPrimary,
                          ),
                        ),
                      ),
                      if (sale.paymentMethod == m)
                        const Icon(Icons.check_circle, color: colorPrimary, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _cashSection(PosSaleController sale) {
    final total = sale.cartTotal;
    final paid = _paid;
    final enough = paid >= total && total > 0;
    final change = enough ? paid - total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _received,
          keyboardType: TextInputType.number,
          inputFormatters: [PriceInputFormatter()],
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.poppins(fontSize: 16, color: colorTextPrimary),
          decoration: InputDecoration(
            labelText: 'Amount received',
            prefixText: 'Rp ',
            filled: true,
            fillColor: colorCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: colorGreyLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: colorPrimary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final a in _quickAmounts(total))
              ActionChip(
                label: Text(a == total ? 'Exact' : formatPrice(a)),
                onPressed: () => setState(() => _received.text = formatPrice(a)),
                backgroundColor: colorCard,
                side: const BorderSide(color: colorGreyLight),
                labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorGreyLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Change', style: GoogleFonts.poppins(fontSize: 13, color: colorTextSubtle)),
              Text(
                paid == 0 || enough ? sessionMoney(change) : 'Insufficient',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: paid == 0 || enough ? colorTextPrimary : colorError,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (enough && !sale.isProcessing) ? () => _payCash(sale) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: sale.isProcessing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite),
                  )
                : Text(
                    'Complete Transaction',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _onlineSection(PosSaleController sale) {
    final order = sale.midtrans;
    final busy = sale.isProcessing || sale.isPolling;

    if (order == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You will be redirected to the ${_label(sale.paymentMethod)} payment page. '
            'Come back to the app after paying.',
            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: busy ? null : () => _startOnline(sale),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: sale.isProcessing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite),
                    )
                  : Text(
                      'Pay with ${_label(sale.paymentMethod)}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SessionInfoCard(
          title: 'Waiting for payment',
          children: [
            SessionInfoRow(label: 'Order ID', value: order.orderId),
            SessionInfoRow(
              label: 'Amount',
              value: sessionMoney(order.totalAmount),
              valueColor: colorPrimary,
              bold: true,
            ),
            const SizedBox(height: 6),
            Text(
              'Finish the payment in the opened page, then tap "I\'ve paid" to confirm.',
              style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
            ),
            if (sale.isPolling) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Waiting for payment confirmation...',
                    style: GoogleFonts.poppins(fontSize: 12, color: colorPrimary),
                  ),
                ],
              ),
            ],
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: busy ? null : () => _confirmOnline(sale),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              busy ? 'Checking...' : "I've paid, check status",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: busy ? null : () => _openUrl(order.redirectUrl),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: colorPrimary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Open payment page again',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorPrimary),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton(
            onPressed: sale.isProcessing ? null : sale.cancelOnlinePayment,
            child: Text('Cancel payment', style: GoogleFonts.poppins(color: colorError)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payment',
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
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _amountDue(sale),
              const SizedBox(height: 16),
              Text(
                'Payment method',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _methodTiles(sale),
              const SizedBox(height: 8),
              if (sale.paymentMethod == 'CASH') _cashSection(sale) else _onlineSection(sale),
              if (sale.paymentError != null) ...[
                const SizedBox(height: 12),
                Text(
                  sale.paymentError!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: colorError),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}