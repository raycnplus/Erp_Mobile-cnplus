import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_session_controller.dart';

class PosOpenSessionView extends StatefulWidget {
  const PosOpenSessionView({super.key});

  @override
  State<PosOpenSessionView> createState() => _PosOpenSessionViewState();
}

class _PosOpenSessionViewState extends State<PosOpenSessionView> {
  final TextEditingController _amount = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _open(PosSessionController ctrl) async {
    if (_amount.text.trim().isEmpty) {
      setState(() => _localError = 'Opening balance is required');
      return;
    }
    setState(() => _localError = null);
    await ctrl.openSession(parsePrice(_amount.text));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PosSessionController>(
      builder: (context, ctrl, child) {
        final error = _localError ?? ctrl.formError;

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              color: colorCard,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: colorGreyLight, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.point_of_sale, size: 56, color: colorPrimary),
                    const SizedBox(height: 12),
                    Text(
                      'Open Cashier Session',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colorTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ctrl.storeName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 13, color: colorTextSubtle),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _amount,
                      keyboardType: TextInputType.number,
                      inputFormatters: [PriceInputFormatter()],
                      style: GoogleFonts.poppins(fontSize: 15, color: colorTextPrimary),
                      decoration: InputDecoration(
                        labelText: 'Opening balance',
                        prefixText: 'Rp ',
                        filled: true,
                        fillColor: colorBackground,
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
                    if (error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 12, color: colorError),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ctrl.isSubmitting ? null : () => _open(ctrl),
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
                                'Open Session',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}