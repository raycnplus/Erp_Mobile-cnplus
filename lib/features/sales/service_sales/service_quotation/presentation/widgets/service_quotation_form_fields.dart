import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/controllers/service_quotation_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/models/service_quotation_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_switch.dart';

class ServiceQuotationFormFields extends StatefulWidget {
  final ServiceQuotationFormModel formData;
  final ServiceQuotationFormOptions? formOptions;
  final VoidCallback onSave;
  final bool isSaving;

  const ServiceQuotationFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<ServiceQuotationFormFields> createState() => _State();
}

class _State extends State<ServiceQuotationFormFields>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _noteCtrl = TextEditingController();

  final Map<String, TextEditingController> _itemCtrls = {};

  TextEditingController _itemCtrl(int i, String field, double value) {
    final key = '${i}_$field';
    if (!_itemCtrls.containsKey(key)) {
      _itemCtrls[key] = TextEditingController(
        text: value > 0 ? value.toStringAsFixed(2) : '',
      );
    }
    return _itemCtrls[key]!;
  }

  void _removeItemCtrls(int i) {
    final toRemove =
        _itemCtrls.keys.where((k) => k.startsWith('${i}_')).toList();
    for (final k in toRemove) {
      _itemCtrls[k]!.dispose();
      _itemCtrls.remove(k);
    }
    for (int j = i + 1; j <= widget.formData.items.length; j++) {
      for (final field in [
        'qty',
        'unitPrice',
        'discountRate',
        'discountAmount',
      ]) {
        final oldKey = '${j}_$field';
        final newKey = '${j - 1}_$field';
        if (_itemCtrls.containsKey(oldKey)) {
          _itemCtrls[newKey] = _itemCtrls.remove(oldKey)!;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _noteCtrl.text = widget.formData.note ?? '';
  }

  @override
  void dispose() {
    _tab.dispose();
    _noteCtrl.dispose();
    for (final c in _itemCtrls.values) c.dispose();
    super.dispose();
  }

  ServiceQuotationFormOptions? get _opts => widget.formOptions;
  double get _taxRate => _opts?.defaultTaxRate ?? 11.0;

  void _recalcItem(int idx) {
    widget.formData.items[idx].recalculate(
      isTaxEnabled: widget.formData.isTax,
      defaultTaxRate: _taxRate,
      discountType: widget.formData.discountType,
    );
    setState(() {});
  }

  void _recalcAll() {
    for (int i = 0; i < widget.formData.items.length; i++) {
      _recalcItem(i);
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: colorError,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  bool _validateAndSync() {
    widget.formData.note = _noteCtrl.text.trim().isEmpty
        ? null
        : _noteCtrl.text.trim();

    if (widget.formData.idCustomer == null) {
      _snack('Please select customer');
      return false;
    }
    if (widget.formData.salesPerson == null) {
      _snack('Please select sales person');
      return false;
    }
    if (widget.formData.validityDate == null) {
      _snack('Please select validity date');
      return false;
    }
    if (widget.formData.items.isEmpty) {
      _snack('Please add at least one service');
      return false;
    }

    for (int i = 0; i < widget.formData.items.length; i++) {
      final item = widget.formData.items[i];
      if (item.idService == null) {
        _snack('Row ${i + 1}: Please select service');
        return false;
      }
      if (item.qty <= 0) {
        _snack('Row ${i + 1}: Qty must be > 0');
        return false;
      }
    }
    return true;
  }

  Future<void> _addService() async {
    final ctrl = context.read<ServiceQuotationController>();
    final services = _opts?.services ?? [];
    if (services.isEmpty) {
      _snack('No services available');
      return;
    }

    SQServiceOption? selected;

    final result = await showDialog<SQServiceOption>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text(
            'Add Service',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSearchableDropdown<SQServiceOption>(
                  value: selected,
                  items: services,
                  itemLabel: (s) => s.serviceName,
                  onChanged: (v) => setSt(() => selected = v),
                  label: 'Service',
                  isRequired: true,
                  clearable: false,
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: colorGreyDark),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selected == null) {
                  _snack('Please select service');
                  return;
                }
                Navigator.pop(ctx, selected);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Add', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      double unitPrice = result.unitPrice;
      if (widget.formData.idPriceList != null && unitPrice == 0) {
        unitPrice =
            await ctrl.fetchPriceFromList(
              result.idService,
              widget.formData.idPriceList!,
            ) ??
            result.unitPrice;
      }
      setState(() {
        widget.formData.items.add(
          ServiceQuotationFormItem(
            idService: result.idService,
            serviceName: result.serviceName,
            description: result.description,
            qty: 1,
            unitPrice: unitPrice,
            taxRate: widget.formData.isTax ? _taxRate : 0,
          ),
        );
        _recalcItem(widget.formData.items.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: [
            const Tab(text: 'Header'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Services'),
                  if (widget.formData.items.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${widget.formData.items.length}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: colorWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [_buildHeaderTab(), _buildServicesTab()],
          ),
        ),
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
          CustomSearchableDropdown<SQCustomerOption>(
            key: ValueKey(
              'cust_${widget.formData.idCustomer}_${_opts?.customers.length}',
            ),
            value: _opts?.customers
                .where((c) => c.id == widget.formData.idCustomer)
                .firstOrNull,
            items: _opts?.customers ?? [],
            itemLabel: (c) => c.name,
            onChanged: (v) =>
                setState(() => widget.formData.idCustomer = v?.id),
            isRequired: true,
            label: 'Customer',
            clearable: false,
          ),
          const SizedBox(height: 14),
          CustomSearchableDropdown<SQSalesPersonOption>(
            key: ValueKey('sp_${widget.formData.salesPerson}_${_opts?.salesPersons.length}'),
            value: _opts?.salesPersons.where((s) => s.id == widget.formData.salesPerson).firstOrNull,
            items: _opts?.salesPersons ?? [],
            itemLabel: (s) => s.name,
            onChanged: (v) => setState(() => widget.formData.salesPerson = v?.id),
            isRequired: true,
            label: 'Salesperson',
            clearable: false,
          ),
          const SizedBox(height: 14),
          _sectionLabel('Validity Date *'),
          _datePicker(
            value: widget.formData.validityDate,
            hint: 'Select validity date',
            onPicked: (d) =>
                setState(() => widget.formData.validityDate = d),
          ),
          const SizedBox(height: 14),
          CustomSearchableDropdown<SQPaymentTermOption>(
            key: ValueKey(
              'pt_${widget.formData.idPaymentTerm}_${_opts?.paymentTerms.length}',
            ),
            value: _opts?.paymentTerms
                .where((p) => p.id == widget.formData.idPaymentTerm)
                .firstOrNull,
            items: _opts?.paymentTerms ?? [],
            itemLabel: (p) => p.name,
            label: 'Payment Term',
            onChanged: (v) =>
                setState(() => widget.formData.idPaymentTerm = v?.id),
          ),
          const SizedBox(height: 14),
          CustomSearchableDropdown<SQPriceListOption>(
            key: ValueKey(
              'pl_${widget.formData.idPriceList}_${_opts?.priceLists.length}',
            ),
            value: _opts?.priceLists
                .where((p) => p.id == widget.formData.idPriceList)
                .firstOrNull,
            items: _opts?.priceLists ?? [],
            itemLabel: (p) => p.name,
            label: 'Price List',
            onChanged: (v) =>
                setState(() => widget.formData.idPriceList = v?.id),
          ),
          const SizedBox(height: 14),
          _sectionLabel('Discount Type'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _discChip('No Discount', null),
              _discChip('Percentage (%)', 'Percentage'),
              _discChip('Nominal (Rp)', 'Nominal'),
            ],
          ),
          const SizedBox(height: 14),
          CustomFormSwitchHorizontal(
            label: 'PPN',
            subtitle: '${_taxRate.toStringAsFixed(0)}% dari subtotal',
            value: widget.formData.isTax,
            onChanged: (v) {
              setState(() => widget.formData.isTax = v);
              _recalcAll();
            },
          ),
          const SizedBox(height: 14),
          CustomFormInput(
            controller: _noteCtrl,
            label: 'Note',
            hintText: 'Write note for this quotation (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return Column(
      children: [
        Expanded(
          child: widget.formData.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.design_services_outlined,
                        size: 64,
                        color: colorGrey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No services added',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: colorTextSubtle,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _addService,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(
                          'Add Service',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  itemCount: widget.formData.items.length,
                  itemBuilder: (_, i) => _buildItemCard(i),
                ),
        ),
        if (widget.formData.items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addService,
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  'Add Service',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: colorPrimary,
                  side: const BorderSide(color: colorPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        if (widget.formData.items.isNotEmpty) _buildTotalsFooter(),
      ],
    );
  }

  Widget _buildItemCard(int i) {
    final item = widget.formData.items[i];
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.serviceName ?? 'Service ${i + 1}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: colorTextPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: colorError,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => setState(() {
                    _removeItemCtrls(i);
                    widget.formData.items.removeAt(i);
                  }),
                ),
              ],
            ),
            if (item.description?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  item.description!,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: colorTextSubtle,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            CustomFormInput(
              controller: _itemCtrl(i, 'desc', 0)
                ..text = item.description ?? '',
              label: 'Description (optional)',
              hintText: 'Service description',
              onChanged: (v) => item.description = v,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _numField(
                    ctrl: _itemCtrl(i, 'qty', item.qty),
                    label: 'Qty',
                    required: true,
                    onChanged: (v) => setState(() {
                      item.qty = v;
                      _recalcItem(i);
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _numField(
                    ctrl: _itemCtrl(i, 'unitPrice', item.unitPrice),
                    label: 'Unit Price',
                    required: true,
                    onChanged: (v) => setState(() {
                      item.unitPrice = v;
                      _recalcItem(i);
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (widget.formData.discountType == 'Percentage') ...[
              _numField(
                ctrl: _itemCtrl(i, 'discountRate', item.discountRate),
                label: 'Discount (%)',
                onChanged: (v) => setState(() {
                  item.discountRate = v.clamp(0, 100);
                  _recalcItem(i);
                }),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.remove_circle_outline,
                    size: 14,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Discount Rp ${_fmtNum(item.discountAmount)}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            if (widget.formData.discountType == 'Nominal') ...[
              _numField(
                ctrl: _itemCtrl(i, 'discountAmount', item.discountAmount),
                label: 'Discount (Rp)',
                onChanged: (v) => setState(() {
                  item.discountAmount =
                      v.clamp(0, item.subtotalBeforeDiscount);
                  _recalcItem(i);
                }),
              ),
              const SizedBox(height: 4),
            ],
            if (widget.formData.isTax && item.taxAmount > 0) ...[
              Row(
                children: [
                  const Icon(
                    Icons.receipt_outlined,
                    size: 14,
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'PPN (${_taxRate.toStringAsFixed(0)}%): Rp ${_fmtNum(item.taxAmount)}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            const Divider(height: 12, color: colorGreyLight),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: colorTextSubtle,
                  ),
                ),
                Text(
                  'Rp ${_fmtNum(item.taxedAmount)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: colorPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsFooter() => Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        color: colorCard,
        child: Column(
          children: [
            if (widget.formData.totalDiscount > 0)
              _footerRow(
                'Total Discount',
                'Rp ${_fmtNum(widget.formData.totalDiscount)}',
                color: Colors.orange.shade700,
              ),
            _footerRow(
              'Untaxed Amount',
              'Rp ${_fmtNum(widget.formData.untaxedAmount)}',
            ),
            if (widget.formData.isTax)
              _footerRow(
                'PPN (${_taxRate.toStringAsFixed(0)}%)',
                'Rp ${_fmtNum(widget.formData.totalTaxes)}',
                color: Colors.indigo,
              ),
            const Divider(height: 14, color: colorGreyLight),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grand Total',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: colorTextPrimary,
                  ),
                ),
                Text(
                  'Rp ${_fmtNum(widget.formData.grandTotal)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildBottomBar() => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: colorCard,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.isSaving
                ? null
                : () {
                    if (_validateAndSync()) widget.onSave();
                  },
            icon: widget.isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorWhite,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(
              widget.formData.isEditMode
                  ? 'Update Quotation'
                  : 'Save Quotation',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ),
      );

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
      );

  Widget _datePicker({
    required DateTime? value,
    required String hint,
    required ValueChanged<DateTime> onPicked,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate:
              value ?? DateTime.now().add(const Duration(days: 30)),
          firstDate:
              DateTime.now().subtract(const Duration(days: 1)),
          lastDate: DateTime(DateTime.now().year + 3),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme:
                  const ColorScheme.light(primary: colorPrimary),
            ),
            child: child!,
          ),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: value != null ? colorPrimary : colorGreyLight,
            width: value != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: value != null ? colorPrimary : colorGrey,
            ),
            const SizedBox(width: 8),
            Text(
              value != null
                  ? DateFormat('d MMM yyyy').format(value)
                  : hint,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: value != null ? colorTextPrimary : colorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _discChip(String label, String? value) {
    final isSelected = widget.formData.discountType == value;
    return GestureDetector(
      onTap: () => setState(() {
        widget.formData.discountType = value;
        _recalcAll();
      }),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorPrimary : colorBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorPrimary : colorGreyLight,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isSelected ? colorWhite : colorTextPrimary,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _numField({
    required TextEditingController ctrl,
    required String label,
    bool required = false,
    required Function(double) onChanged,
  }) =>
      CustomFormInput(
        controller: ctrl,
        label: label,
        required: required,
        hintText: '0',
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
      );

  Widget _footerRow(String label, String value, {Color? color}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: colorTextSubtle,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: color ?? colorTextPrimary,
              ),
            ),
          ],
        ),
      );

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}