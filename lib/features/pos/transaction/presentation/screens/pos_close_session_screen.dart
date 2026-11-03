import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_session_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

class PosCloseSessionScreen extends StatefulWidget {
  const PosCloseSessionScreen({super.key});

  @override
  State<PosCloseSessionScreen> createState() => _PosCloseSessionScreenState();
}

class _PosCloseSessionScreenState extends State<PosCloseSessionScreen> {
  final TextEditingController _closing = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  String? _localError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PosSessionController>().loadCloseSummary();
    });
  }

  @override
  void dispose() {
    _closing.dispose();
    _notes.dispose();
    super.dispose();
  }

  String _fmtDuration(Duration d) => '${d.inHours}h ${d.inMinutes.remainder(60)}m';

  Future<void> _submit(PosSessionController ctrl) async {
    if (_closing.text.trim().isEmpty) {
      setState(() => _localError = 'Closing balance is required');
      return;
    }
    setState(() => _localError = null);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Close session?', style: GoogleFonts.poppins(fontSize: 16)),
        content: const Text('This cannot be undone. The session will be closed for this store.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorError,
              foregroundColor: colorWhite,
            ),
            child: const Text('Close session'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final ok = await ctrl.closeSession(
      closingBalance: parsePrice(_closing.text),
      notes: _notes.text.trim(),
    );
    if (!ok || !mounted) return;

    final diff = ctrl.lastClosedSession?.difference;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Session closed', style: GoogleFonts.poppins(fontSize: 16)),
        content: Text(
          diff == null || diff.abs() < 0.5
              ? 'Cash balance matches the expected balance.'
              : 'Difference: ${sessionMoney(diff)}',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (mounted) Navigator.pop(context, true);
  }

  Widget _differenceCard(PosSessionController ctrl) {
    if (_closing.text.trim().isEmpty) {
      return SessionInfoCard(
        children: [
          SessionInfoRow(label: 'Difference', value: 'Auto-calculated after input'),
        ],
      );
    }

    final diff = ctrl.differenceFor(parsePrice(_closing.text));
    final Color c;
    final String label;
    if (diff.abs() < 0.5) {
      c = Colors.green;
      label = 'Balanced';
    } else if (diff < 0) {
      c = Colors.red;
      label = 'Short';
    } else {
      c = Colors.orange;
      label = 'Over';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: c)),
          Text(
            sessionMoney(diff),
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: c),
          ),
        ],
      ),
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
          'Close Session',
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
      body: Consumer<PosSessionController>(
        builder: (context, ctrl, child) {
          final s = ctrl.closeSummary;

          if (ctrl.summaryError != null && s == null) {
            return SessionErrorState(
              message: ctrl.summaryError!,
              onRetry: () => ctrl.loadCloseSummary(),
            );
          }
          if (s == null) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }

          final error = _localError ?? ctrl.formError;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (s.unpaidOrders > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${s.unpaidOrders} unpaid order(s) in this session',
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.orange.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
              SessionInfoCard(
                title: 'Session',
                children: [
                  SessionInfoRow(label: 'Store', value: sessionDash(ctrl.storeName)),
                  SessionInfoRow(label: 'Opened At', value: sessionDash(s.openingTime)),
                  SessionInfoRow(label: 'Duration', value: _fmtDuration(s.duration)),
                  SessionInfoRow(label: 'Paid Transactions', value: '${s.totalOrders}'),
                ],
              ),
              SessionInfoCard(
                title: 'Summary',
                children: [
                  SessionInfoRow(label: 'Opening Balance', value: sessionMoney(s.openingBalance)),
                  SessionInfoRow(
                    label: 'Cash Sales',
                    value: sessionMoney(s.cashSales),
                    valueColor: Colors.green,
                  ),
                  SessionInfoRow(
                    label: 'Non-Cash Sales (QRIS/VA)',
                    value: sessionMoney(s.nonCashSales),
                  ),
                  SessionInfoRow(
                    label: 'Cash In',
                    value: sessionMoney(s.totalCashIn),
                    valueColor: Colors.green,
                  ),
                  SessionInfoRow(
                    label: 'Cash Out',
                    value: sessionMoney(s.totalCashOut),
                    valueColor: Colors.red,
                  ),
                  const Divider(height: 20, color: colorGreyLight),
                  SessionInfoRow(
                    label: 'Expected Balance',
                    value: sessionMoney(s.expectedBalance),
                    valueColor: colorPrimary,
                    bold: true,
                  ),
                  Text(
                    'Opening + Cash sales + In − Out',
                    style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                  ),
                ],
              ),
              TextField(
                controller: _closing,
                keyboardType: TextInputType.number,
                inputFormatters: [PriceInputFormatter()],
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(fontSize: 15, color: colorTextPrimary),
                decoration: InputDecoration(
                  labelText: 'Closing balance (cash counted)',
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
              const SizedBox(height: 12),
              _differenceCard(ctrl),
              TextField(
                controller: _notes,
                maxLines: 2,
                maxLength: 255,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'Explain any discrepancy',
                  filled: true,
                  fillColor: colorCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: colorGreyLight),
                  ),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 4),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: colorError),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ctrl.isSubmitting ? null : () => _submit(ctrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorError,
                    foregroundColor: colorWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: ctrl.isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite),
                        )
                      : Text(
                          'Close Session',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}