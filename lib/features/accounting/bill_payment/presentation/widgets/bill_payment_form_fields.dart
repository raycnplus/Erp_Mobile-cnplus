import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/models/bill_payment_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/controllers/bill_payment_controller.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_switch.dart';

class BillPaymentFormFields extends StatefulWidget {
  final BillPaymentFormModel formData;
  final BillPaymentFormOptions? formOptions;
  final VoidCallback onSave;
  final bool isSaving;

  const BillPaymentFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<BillPaymentFormFields> createState() => _State();
}

class _State extends State<BillPaymentFormFields> {
  final _amountCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  List<BillOption> _payableBills = [];
  bool _isLoadingBills = false;
  String? _attachmentFileName;

  @override
  void initState() {
    super.initState();
    _amountCtrl.text = widget.formData.amount > 0 ? widget.formData.amount.toStringAsFixed(2) : '';
    _memoCtrl.text = widget.formData.memo ?? '';
    if (widget.formData.idVendor != null) {
      _loadBillsForVendor(widget.formData.idVendor!, keepSelected: true);
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  BillPaymentFormOptions? get _opts => widget.formOptions;

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg), backgroundColor: colorError, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  Future<void> _loadBillsForVendor(int idVendor, {bool keepSelected = false}) async {
    final ctrl = context.read<BillPaymentController>();
    setState(() => _isLoadingBills = true);
    try {
      final bills = await ctrl.getPayableBills(idVendor);
      if (!mounted) return;
      setState(() {
        _payableBills = bills;
        if (!keepSelected) {
          widget.formData.idBill = null;
          widget.formData.billReference = null;
          widget.formData.billUntaxedAmount = 0;
          widget.formData.billGrandTotal = 0;
        }
      });
    } catch (e) {
      if (mounted) _snack('Failed to load bills: $e');
    } finally {
      if (mounted) setState(() => _isLoadingBills = false);
    }
  }

  void _applyBillSelection(BillOption bill) {
    setState(() {
      widget.formData.idBill = bill.id;
      widget.formData.billReference = bill.reference;
      widget.formData.billUntaxedAmount = bill.untaxedAmount;
      widget.formData.billGrandTotal = bill.grandTotal;
      widget.formData.amount = bill.grandTotal;
      _amountCtrl.text = bill.grandTotal.toStringAsFixed(2);
    });
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );
      
      if (result == null || result.isEmpty) return;
      
      final file = result.first;
      final path = file.path;
      if (path == null) return;
      
      setState(() {
        widget.formData.attachmentPath = path;
        _attachmentFileName = file.name;
      });
    } catch (e) {
      _snack('Failed to pick attachment: $e');
    }
  }

  bool _validateAndSync() {
    widget.formData.memo = _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim();
    widget.formData.amount = double.tryParse(_amountCtrl.text) ?? 0;

    if (widget.formData.idVendor == null) { _snack('Please select vendor'); return false; }
    if (widget.formData.idBill == null) { _snack('Please select a bill to pay'); return false; }
    if (widget.formData.paymentDate == null) { _snack('Please select payment date'); return false; }
    if (widget.formData.amount <= 0) { _snack('Amount must be > 0'); return false; }
    if (widget.formData.idBankAccount == null) { _snack('Please select bank account'); return false; }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSearchableDropdown<BPVendorOption>(
                  key: ValueKey('vendor_${widget.formData.idVendor}_${_opts?.vendors.length}'),
                  value: _opts?.vendors.where((v) => v.idVendor == widget.formData.idVendor).firstOrNull,
                  items: _opts?.vendors ?? [],
                  itemLabel: (v) => v.vendorCode?.isNotEmpty == true ? '${v.vendorName}' : v.vendorName,
                  onChanged: (v) => setState(() {
                    widget.formData.idVendor = v?.idVendor;
                    if (v != null) {
                      _loadBillsForVendor(v.idVendor);
                    } else {
                      _payableBills = [];
                      widget.formData.idBill = null;
                    }
                  }),
                  label: 'Vendor',
                  isRequired: true,
                  clearable: false,
                ),
                const SizedBox(height: 14),

                _sectionLabel('Bill to Pay *'),
                const SizedBox(height: 6),
                if (widget.formData.idVendor == null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(color: colorBackground, borderRadius: BorderRadius.circular(10), border: Border.all(color: colorGreyLight)),
                    child: Row(children: [
                      const Icon(Icons.info_outline, size: 16, color: colorGrey),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Select vendor first', style: GoogleFonts.poppins(fontSize: 13, color: colorGrey))),
                    ]),
                  )
                else if (_isLoadingBills)
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Center(child: CircularProgressIndicator(color: colorPrimary)))
                else if (_payableBills.isEmpty && widget.formData.idBill == null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(color: colorBackground, borderRadius: BorderRadius.circular(10), border: Border.all(color: colorGreyLight)),
                    child: Row(children: [
                      const Icon(Icons.check_circle_outline, size: 16, color: colorGrey),
                      const SizedBox(width: 8),
                      Expanded(child: Text('No unpaid bill for this vendor', style: GoogleFonts.poppins(fontSize: 13, color: colorGrey))),
                    ]),
                  )
                else
                  InkWell(
                    onTap: () async {
                      final picked = await showDialog<BillOption>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Select Bill', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                          content: SizedBox(
                            width: double.maxFinite,
                            height: 360,
                            child: _payableBills.isEmpty
                                ? Center(child: Text('No unpaid bill for this vendor', style: GoogleFonts.poppins(color: colorGrey)))
                                : ListView.builder(
                                    itemCount: _payableBills.length,
                                    itemBuilder: (_, i) {
                                      final b = _payableBills[i];
                                      return ListTile(
                                        dense: true,
                                        title: Text(b.reference, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                                        subtitle: Text('Grand Total: Rp ${NumberFormat('#,##0.00', 'id_ID').format(b.grandTotal)}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                                        onTap: () => Navigator.pop(context, b),
                                      );
                                    },
                                  ),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)))],
                        ),
                      );
                      if (picked != null) _applyBillSelection(picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: colorBackground, borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: widget.formData.idBill != null ? colorPrimary : colorGreyLight),
                      ),
                      child: Row(children: [
                        Icon(Icons.receipt_long_outlined, size: 16, color: widget.formData.idBill != null ? colorPrimary : colorGrey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: widget.formData.idBill != null
                              ? Text(
                                  '${widget.formData.billReference} (Rp ${NumberFormat('#,##0.00', 'id_ID').format(widget.formData.billGrandTotal)})',
                                  style: GoogleFonts.poppins(fontSize: 13, color: colorTextPrimary, fontWeight: FontWeight.w500),
                                )
                              : Text('Tap to select bill', style: GoogleFonts.poppins(fontSize: 13, color: colorGrey)),
                        ),
                        const Icon(Icons.chevron_right, size: 16, color: colorGrey),
                      ]),
                    ),
                  ),
                const SizedBox(height: 14),

                _sectionLabel('Payment Date *'),
                _datePicker(
                  value: widget.formData.paymentDate,
                  hint: 'Select payment date',
                  onPicked: (d) => setState(() => widget.formData.paymentDate = d),
                ),
                const SizedBox(height: 14),

                CustomFormInput(
                  controller: _amountCtrl,
                  label: 'Amount *',
                  hintText: '0',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => setState(() => widget.formData.amount = double.tryParse(v) ?? 0),
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: (_opts?.paymentMethods ?? []).contains(widget.formData.paymentMethod) ? widget.formData.paymentMethod : null,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Payment Method *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true, fillColor: colorBackground,
                  ),
                  items: (_opts?.paymentMethods ?? []).map((m) => DropdownMenuItem(
                        value: m,
                        child: Text(m.replaceAll('_', ' '), style: GoogleFonts.poppins(fontSize: 13)),
                      )).toList(),
                  onChanged: (v) => setState(() => widget.formData.paymentMethod = v ?? widget.formData.paymentMethod),
                ),
                const SizedBox(height: 14),

                CustomSearchableDropdown<BPBankAccountOption>(
                  key: ValueKey('bank_${widget.formData.idBankAccount}_${_opts?.bankAccounts.length}'),
                  value: _opts?.bankAccounts.where((b) => b.idBankAccount == widget.formData.idBankAccount).firstOrNull,
                  items: _opts?.bankAccounts ?? [],
                  itemLabel: (b) => b.display,
                  onChanged: (v) => setState(() => widget.formData.idBankAccount = v?.idBankAccount),
                  label: 'Bank Account',
                  isRequired: true,
                  clearable: false,
                ),
                const SizedBox(height: 14),

                CustomFormSwitchHorizontal(
                  label: 'Apply PPh 23',
                  subtitle: 'Withheld 2% from base amount',
                  value: widget.formData.applyPph23,
                  onChanged: (v) => setState(() => widget.formData.applyPph23 = v),
                ),
                const SizedBox(height: 10),
                CustomFormSwitchHorizontal(
                  label: 'Apply PPN',
                  subtitle: 'Add PPN on top of base amount',
                  value: widget.formData.applyPpn,
                  onChanged: (v) => setState(() => widget.formData.applyPpn = v),
                ),
                const SizedBox(height: 14),

                _sectionLabel('Attachment'),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickAttachment,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: colorBackground, borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _attachmentFileName != null ? colorPrimary : colorGreyLight),
                    ),
                    child: Row(children: [
                      Icon(Icons.attach_file, size: 16, color: _attachmentFileName != null ? colorPrimary : colorGrey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _attachmentFileName ?? 'Tap to attach proof of payment (optional)',
                          style: GoogleFonts.poppins(fontSize: 13, color: _attachmentFileName != null ? colorTextPrimary : colorGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 14),

                CustomFormInput(controller: _memoCtrl, label: 'Memo', hintText: 'Additional notes (optional)', maxLines: 3),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildBottomBar() => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(color: colorCard, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))]),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSave(); },
            icon: widget.isSaving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(
              widget.formData.isEditMode ? 'Update' : 'Save',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: colorPrimary, foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0,
            ),
          ),
        ),
      );

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorTextPrimary)),
      );

  Widget _datePicker({required DateTime? value, required String hint, required ValueChanged<DateTime> onPicked}) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context, initialDate: value ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 1), lastDate: DateTime(DateTime.now().year + 3),
          builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: colorPrimary)), child: child!),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colorBackground, borderRadius: BorderRadius.circular(10),
          border: Border.all(color: value != null ? colorPrimary : colorGreyLight, width: value != null ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(Icons.calendar_today_outlined, size: 16, color: value != null ? colorPrimary : colorGrey),
          const SizedBox(width: 8),
          Text(value != null ? DateFormat('d MMM yyyy').format(value) : hint, style: GoogleFonts.poppins(fontSize: 13, color: value != null ? colorTextPrimary : colorGrey)),
        ]),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}