import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/presentation/controllers/return_rn_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/models/return_rn_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class ReturnRNFormFields extends StatefulWidget {
  final ReturnRNFormModel formData;
  final ReturnRNFormOptions? formOptions;
  final VoidCallback onSave;
  final bool isSaving;

  const ReturnRNFormFields({super.key, required this.formData, required this.formOptions, required this.onSave, this.isSaving = false});

  @override
  State<ReturnRNFormFields> createState() => _State();
}

class _State extends State<ReturnRNFormFields> with TickerProviderStateMixin {
  late TabController _tab;
  final _noteCtrl = TextEditingController();
  final List<ValidatedRNOption> _selectedRNs = [];
  final Map<int, TextEditingController> _qtyCtrls = {};

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _noteCtrl.text = widget.formData.note ?? '';
    final seenIds = <int>{};
    for (final item in widget.formData.items) {
      if (item.idReceiptNote != null && !seenIds.contains(item.idReceiptNote)) {
        seenIds.add(item.idReceiptNote!);
        _selectedRNs.add(ValidatedRNOption(idReceiptNote: item.idReceiptNote!, reference: item.productName ?? 'RN #${item.idReceiptNote}'));
      }
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    _noteCtrl.dispose();
    for (final c in _qtyCtrls.values) c.dispose();
    super.dispose();
  }

  ReturnRNFormOptions? get _opts => widget.formOptions;

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg), backgroundColor: colorError, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    widget.formData.note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim();

    if (widget.formData.items.isEmpty) { _snack('Please select at least one Receipt Note with returnable products'); return false; }

    for (int i = 0; i < widget.formData.items.length; i++) {
      final item = widget.formData.items[i];
      if (item.returnQty <= 0) { _snack('Row ${i + 1}: Return quantity must be > 0'); return false; }
      if (item.returnQty > item.availableQty) { _snack('Row ${i + 1}: cannot exceed available qty (${item.availableQty.toStringAsFixed(2)})'); return false; }
      if (item.returnType == null || item.returnType!.isEmpty) { _snack('Row ${i + 1}: Please select Return Type'); return false; }
    }
    return true;
  }

  Future<void> _selectRNs() async {
    final ctrl = context.read<ReturnRNController>();
    List<ValidatedRNOption> options = [];
    final tempSelected = List<ValidatedRNOption>.from(_selectedRNs);

    Future<void> doLoad(StateSetter setSt) async {
      try {
        options = await ctrl.getValidatedRNs();
        setSt(() {});
      } catch (e) {
        _snack('Failed to load Receipt Notes: $e');
      }
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) {
          if (options.isEmpty) doLoad(setSt);
          return AlertDialog(
            title: Text('Select Receipt Note(s)', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: double.maxFinite,
              height: 420,
              child: options.isEmpty
                  ? Center(child: Text('No validated Receipt Note found', style: GoogleFonts.poppins(color: colorGrey)))
                  : ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (_, i) {
                        final o = options[i];
                        final isChecked = tempSelected.any((s) => s.idReceiptNote == o.idReceiptNote);
                        return CheckboxListTile(
                          value: isChecked,
                          onChanged: (v) => setSt(() {
                            if (v == true) {
                              tempSelected.add(o);
                            } else {
                              tempSelected.removeWhere((s) => s.idReceiptNote == o.idReceiptNote);
                            }
                          }),
                          title: Text(o.reference, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        );
                      },
                    ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark))),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                child: Text('Done (${tempSelected.length})', style: GoogleFonts.poppins()),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _selectedRNs
          ..clear()
          ..addAll(tempSelected);
      });
      await _loadItemsFromSelectedRNs();
    }
  }

  Future<void> _loadItemsFromSelectedRNs() async {
    if (_selectedRNs.isEmpty) {
      setState(() {
        widget.formData.items = [];
        for (final c in _qtyCtrls.values) c.dispose();
        _qtyCtrls.clear();
      });
      return;
    }

    final ctrl = context.read<ReturnRNController>();
    try {
      final ids = _selectedRNs.map((rn) => rn.idReceiptNote).toList();
      final items = await ctrl.getItemsByRN(ids);
      if (!mounted) return;

      if (items.isEmpty) {
        _snack('No returnable products found for the selected Receipt Note(s)');
      }

      setState(() {
        for (final c in _qtyCtrls.values) c.dispose();
        _qtyCtrls.clear();
        widget.formData.items = items.map((i) => ReturnRNFormItem(
              idProduct: i.idProduct,
              productName: i.productName,
              uomId: i.uomId,
              uomName: i.uomName,
              availableQty: i.remainingQty,
              deliveredQty: i.deliveredQty,
              returnQty: 0,
              returnType: null,
              idReceiptNote: i.idReceiptNote,
              idReceiptNoteItem: i.idReceiptNoteItem,
            )).toList();
        for (final item in widget.formData.items) {
          _qtyCtrls[item.idReceiptNoteItem!] = TextEditingController();
        }
      });
    } catch (e) {
      if (mounted) _snack('Failed to load items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary, unselectedLabelColor: colorTextSubtle, indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: [
            const Tab(text: 'Header'),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Flexible(child: Text('Products', overflow: TextOverflow.ellipsis)),
              if (widget.formData.items.isNotEmpty) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(10)),
                  child: Text('${widget.formData.items.length}', style: GoogleFonts.poppins(fontSize: 10, color: colorWhite, fontWeight: FontWeight.w600)),
                ),
              ],
            ])),
          ],
        ),
        Expanded(child: TabBarView(controller: _tab, children: [_buildHeaderTab(), _buildProductsTab()])),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildHeaderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Source Receipt Note(s)', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: colorPrimary)),
              TextButton.icon(
                onPressed: _selectRNs,
                icon: const Icon(Icons.add, size: 16),
                label: Text('Select', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (_selectedRNs.isEmpty)
            InkWell(
              onTap: _selectRNs,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: colorBackground, borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colorGreyLight),
                ),
                child: Row(children: [
                  const Icon(Icons.receipt_long_outlined, size: 18, color: colorGrey),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Tap to select Receipt Note(s)', style: GoogleFonts.poppins(fontSize: 13, color: colorGrey))),
                ]),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedRNs.map((rn) => Chip(
                    label: Text(rn.reference, style: GoogleFonts.poppins(fontSize: 12)),
                    onDeleted: () async {
                      setState(() => _selectedRNs.removeWhere((s) => s.idReceiptNote == rn.idReceiptNote));
                      await _loadItemsFromSelectedRNs();
                    },
                    backgroundColor: colorPrimary.withOpacity(0.1),
                    deleteIconColor: colorError,
                  )).toList(),
            ),
          const SizedBox(height: 20),

          _sectionLabel('Scheduled Date'),
          _datePicker(
            value: widget.formData.scheduledDate,
            hint: 'Select scheduled date (optional)',
            onPicked: (d) => setState(() => widget.formData.scheduledDate = d),
          ),
          const SizedBox(height: 20),

          CustomFormInput(controller: _noteCtrl, label: 'Note', hintText: 'Write note for this return (optional)', maxLines: 3),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    if (widget.formData.items.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.inventory_2_outlined, size: 64, color: colorGrey),
          const SizedBox(height: 12),
          Text('No products', style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle)),
          const SizedBox(height: 4),
          Text('Select one or more Receipt Notes first to load returnable products', style: GoogleFonts.poppins(fontSize: 12, color: colorGrey), textAlign: TextAlign.center),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.formData.items.length,
      itemBuilder: (_, i) => _buildItemCard(i),
    );
  }

  Widget _buildItemCard(int i) {
    final item = widget.formData.items[i];
    final ctrl = _qtyCtrls.putIfAbsent(
      item.idReceiptNoteItem!,
      () => TextEditingController(text: item.returnQty > 0 ? item.returnQty.toStringAsFixed(2) : ''),
    );
    final returnTypes = _opts?.returnTypes ?? const ['Return', 'Replace', 'Repair'];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.productName ?? 'Product ${i + 1}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary)),
            const SizedBox(height: 2),
            Text('Available to return: ${item.availableQty.toStringAsFixed(2)} ${item.uomName ?? ''}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                isDense: true, labelText: 'Return Qty *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (v) => item.returnQty = double.tryParse(v) ?? 0,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: returnTypes.contains(item.returnType) ? item.returnType : null,
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Return Type *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              hint: Text('Select Type', style: GoogleFonts.poppins(fontSize: 13, color: colorGrey)),
              items: returnTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.poppins(fontSize: 13))))
                  .toList(),
              onChanged: (v) => setState(() => item.returnType = v),
            ),
          ],
        ),
      ),
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
            label: Text(widget.formData.isEditMode ? 'Update Return RN' : 'Save Return RN', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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