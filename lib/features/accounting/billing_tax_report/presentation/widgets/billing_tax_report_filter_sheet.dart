import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/presentation/controllers/billing_tax_report_controller.dart';

const List<String> _kMonthLabels = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

class BillingTaxReportFilterSheet extends StatefulWidget {
  const BillingTaxReportFilterSheet({super.key});

  @override
  State<BillingTaxReportFilterSheet> createState() =>
      _BillingTaxReportFilterSheetState();
}

class _BillingTaxReportFilterSheetState
    extends State<BillingTaxReportFilterSheet> {
  late int _year;
  late String _month;
  late String _customerId;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<BillingTaxReportController>();
    _year = ctrl.year;
    _month = ctrl.month;
    _customerId = ctrl.customerId;
  }

  void _warn(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: colorError),
    );
  }

  void _onApply() {
    if (_year.toString().length != 4) {
      _warn('Masukkan tahun yang valid (4 digit).');
      return;
    }

    final ctrl = context.read<BillingTaxReportController>();
    ctrl.setYear(_year);
    ctrl.setMonth(_month);
    ctrl.selectCustomer(_customerId);
    ctrl.applyFilter();
    Navigator.pop(context);
  }

  void _onReset() {
    context.read<BillingTaxReportController>().resetFilter();
    Navigator.pop(context);
  }

  OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<BillingTaxReportController>(
      builder: (context, ctrl, child) {
        final customers = ctrl.formOptions?.customers ?? [];
        final customerValues = <String>[
          kBillingTaxAllCustomer,
          ...customers.map((c) => c.idCustomer.toString()),
        ];
        final customerLabels = <String, String>{
          kBillingTaxAllCustomer: 'All Customer',
          for (final c in customers) c.idCustomer.toString(): c.customerName,
        };

        final monthValues = <String>[
          kBillingTaxAllMonth,
          for (var m = 1; m <= 12; m++) m.toString(),
        ];
        final monthLabels = <String, String>{
          kBillingTaxAllMonth: 'All Month',
          for (var m = 1; m <= 12; m++) m.toString(): _kMonthLabels[m - 1],
        };

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
                  'Filter Billing Tax Report',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                CustomSearchableDropdown<String>(
                  value: _customerId,
                  items: customerValues,
                  itemLabel: (v) => customerLabels[v] ?? v,
                  onChanged: (val) => setState(
                      () => _customerId = val ?? kBillingTaxAllCustomer),
                  label: 'Customer',
                  hintText: 'All Customer',
                  clearable: false,
                ),

                const SizedBox(height: 14),

                CustomSearchableDropdown<String>(
                  value: _month,
                  items: monthValues,
                  itemLabel: (v) => monthLabels[v] ?? v,
                  onChanged: (val) =>
                      setState(() => _month = val ?? kBillingTaxAllMonth),
                  label: 'Month',
                  hintText: 'All Month',
                  clearable: false,
                ),

                const SizedBox(height: 16),

                const FilterSectionLabel('Year *'),
                TextFormField(
                  initialValue: _year.toString(),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: colorTextPrimary,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: colorCard,
                    hintText: 'e.g. ${DateTime.now().year}',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: colorGrey,
                    ),
                    prefixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: colorGrey,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    enabledBorder: _border(colorGreyLight, 1),
                    focusedBorder: _border(colorPrimary, 1.5),
                    border: _border(colorGreyLight, 1),
                  ),
                  onChanged: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null) _year = parsed;
                  },
                ),

                const SizedBox(height: 20),

                FilterActionButtons(onReset: _onReset, onApply: _onApply),
              ],
            ),
          ),
        );
      },
    );
  }
}