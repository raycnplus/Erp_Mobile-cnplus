import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/data/models/pos_transaction_models.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_session_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

void showPosCashMovementSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colorCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => ChangeNotifierProvider.value(
      value: context.read<PosSessionController>(),
      child: const PosCashMovementSheet(),
    ),
  );
}

class PosCashMovementSheet extends StatefulWidget {
  const PosCashMovementSheet({super.key});

  @override
  State<PosCashMovementSheet> createState() => _PosCashMovementSheetState();
}

class _PosCashMovementSheetState extends State<PosCashMovementSheet> {
  String _type = 'IN';
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  String? _localError;
  String? _info;

  @override
  void dispose() {
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save(PosSessionController ctrl) async {
    final amount = parsePrice(_amount.text);
    if (amount < 1) {
      setState(() {
        _localError = 'Amount must be at least 1';
        _info = null;
      });
      return;
    }

    setState(() {
      _localError = null;
      _info = null;
    });

    final ok = await ctrl.addCashMovement(
      type: _type,
      amount: amount,
      notes: _notes.text.trim(),
    );
    if (!mounted) return;

    if (ok) {
      ctrl.consumeSuccessMessage();
      _amount.clear();
      _notes.clear();
      setState(() => _info = 'Cash movement saved');
    }
  }

  Widget _typeCard(String type, String title, IconData icon, Color color) {
    final selected = _type == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _type = type),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.1) : colorCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? color : colorGreyLight,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: selected ? color : colorGrey),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? color : colorTextSubtle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ledgerItem(PosSessionController ctrl, PosCashMovement m) {
    final color = m.isIn ? Colors.green : Colors.red;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(
              m.isIn ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (m.notes == null || m.notes!.trim().isEmpty) ? 'No notes' : m.notes!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  sessionDash(m.createdAt),
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                ),
              ],
            ),
          ),
          Text(
            '${m.isIn ? '+' : '-'} ${sessionMoney(m.amount)}',
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: color),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete_outline, size: 18, color: colorGrey),
            onPressed: ctrl.isSubmitting ? null : () => ctrl.deleteCashMovement(m),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PosSessionController>(
      builder: (context, ctrl, child) {
        final s = ctrl.session;
        final error = _localError ?? ctrl.formError;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cash In / Cash Out',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _typeCard('IN', 'Cash In', Icons.arrow_downward, Colors.green),
                    const SizedBox(width: 10),
                    _typeCard('OUT', 'Cash Out', Icons.arrow_upward, Colors.red),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  inputFormatters: [PriceInputFormatter()],
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _notes,
                  maxLength: 255,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                if (error != null)
                  Text(error, style: GoogleFonts.poppins(fontSize: 12, color: colorError)),
                if (_info != null && error == null)
                  Text(_info!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.green)),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ctrl.isSubmitting ? null : () => _save(ctrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
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
                            'Save movement',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                if (s != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Cash In',
                                  style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                              Text(
                                sessionMoney(s.totalCashIn),
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Total Cash Out',
                                  style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                              Text(
                                sessionMoney(s.totalCashOut),
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  'Recorded in this app session',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorTextSubtle,
                  ),
                ),
                const SizedBox(height: 4),
                if (ctrl.movements.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No movement yet',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
                    ),
                  )
                else
                  for (final m in ctrl.movements) _ledgerItem(ctrl, m),
              ],
            ),
          ),
        );
      },
    );
  }
}