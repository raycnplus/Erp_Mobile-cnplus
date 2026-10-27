import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

String formatFilterDate(DateTime? d, {String placeholder = 'Select date'}) =>
    d == null
    ? placeholder
    : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

Future<DateTime?> pickFilterDate(
  BuildContext context, {
  DateTime? initial,
}) {
  return showDatePicker(
    context: context,
    initialDate: initial ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
    builder: (ctx, child) => Theme(
      data: Theme.of(ctx).copyWith(
        colorScheme: const ColorScheme.light(primary: colorPrimary),
      ),
      child: child!,
    ),
  );
}

class FilterSectionLabel extends StatelessWidget {
  final String label;
  const FilterSectionLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class FilterDatePickerBox extends StatelessWidget {
  final DateTime? value;
  final VoidCallback onTap;
  final String placeholder;

  const FilterDatePickerBox({
    super.key,
    required this.value,
    required this.onTap,
    this.placeholder = 'Select date',
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colorCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasValue ? colorPrimary : colorGreyLight,
            width: hasValue ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: hasValue ? colorPrimary : colorGrey,
            ),
            const SizedBox(width: 8),
            Text(
              formatFilterDate(value, placeholder: placeholder),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: hasValue ? colorTextPrimary : colorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDateRangeRow extends StatelessWidget {
  final String fromLabel;
  final String toLabel;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final VoidCallback onTapFrom;
  final VoidCallback onTapTo;
  final String placeholder;

  const FilterDateRangeRow({
    super.key,
    this.placeholder = 'Select date',
    this.fromLabel = 'Start Date',
    this.toLabel = 'End Date',
    required this.dateFrom,
    required this.dateTo,
    required this.onTapFrom,
    required this.onTapTo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterSectionLabel(fromLabel),
              FilterDatePickerBox(
                value: dateFrom,
                onTap: onTapFrom,
                placeholder: placeholder,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterSectionLabel(toLabel),
              FilterDatePickerBox(
                value: dateTo,
                onTap: onTapTo,
                placeholder: placeholder,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FilterActionButtons extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const FilterActionButtons({
    super.key,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onReset,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: colorGreyLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Reset',
              style: GoogleFonts.poppins(color: colorTextPrimary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Apply Filter',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

const Map<String, String> _kFilterTypeLabels = {
  'today': 'Today',
  'end_of_month': 'End of Month',
  'end_of_quarter': 'End of Quarter',
  'end_of_year': 'End of Year',
  'custom': 'Custom Date',
};

const Map<String, String> _kQuarterLabels = {
  'Q1': 'Jan - Mar (Q1)',
  'Q2': 'Apr - Jun (Q2)',
  'Q3': 'Jul - Sep (Q3)',
  'Q4': 'Oct - Dec (Q4)',
};

const List<String> _kMonthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

class PeriodFilterSheet extends StatefulWidget {
  final String title;
  final List<String> filterTypes;

  final String initialFilterType;
  final DateTime? initialCustomDate;
  final int? initialMonth;
  final int? initialMonthYear;
  final String initialQuarter;
  final int? initialYear;

  final void Function(String) onSetFilterType;
  final void Function(DateTime) onSetCustomDate;
  final void Function(int, int) onSetMonth;
  final void Function(String) onSetQuarter;
  final void Function(int) onSetYear;
  final VoidCallback onApplyFilter;
  final VoidCallback onResetFilter;

  const PeriodFilterSheet({
    super.key,
    required this.title,
    required this.filterTypes,
    required this.initialFilterType,
    required this.initialCustomDate,
    required this.initialMonth,
    required this.initialMonthYear,
    required this.initialQuarter,
    required this.initialYear,
    required this.onSetFilterType,
    required this.onSetCustomDate,
    required this.onSetMonth,
    required this.onSetQuarter,
    required this.onSetYear,
    required this.onApplyFilter,
    required this.onResetFilter,
  });

  @override
  State<PeriodFilterSheet> createState() => _PeriodFilterSheetState();
}

class _PeriodFilterSheetState extends State<PeriodFilterSheet> {
  late String _filterType;
  DateTime? _customDate;
  int? _month;
  int _monthYear = DateTime.now().year;
  String _quarter = 'Q1';
  int _year = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _filterType = widget.initialFilterType;
    _customDate = widget.initialCustomDate;
    _month = widget.initialMonth ?? DateTime.now().month;
    _monthYear = widget.initialMonthYear ?? DateTime.now().year;
    _quarter = widget.initialQuarter;
    _year = widget.initialYear ?? DateTime.now().year;
  }

  List<int> get _yearOptions =>
      List.generate(10, (i) => DateTime.now().year - 5 + i);

  Future<void> _pickCustomDate() async {
    final picked = await pickFilterDate(context, initial: _customDate);
    if (picked != null) setState(() => _customDate = picked);
  }

  void _warn(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: colorError),
    );
  }

  void _onApply() {
    widget.onSetFilterType(_filterType);

    switch (_filterType) {
      case 'custom':
        if (_customDate == null) {
          _warn('Please select a date!');
          return;
        }
        widget.onSetCustomDate(_customDate!);
        break;
      case 'end_of_month':
        if (_month == null) {
          _warn('Please select a month!');
          return;
        }
        widget.onSetMonth(_month!, _monthYear);
        break;
      case 'end_of_quarter':
        widget.onSetQuarter(_quarter);
        widget.onSetYear(_year);
        break;
      case 'end_of_year':
        widget.onSetYear(_year);
        break;
    }

    widget.onApplyFilter();
    Navigator.pop(context);
  }

  void _onReset() {
    widget.onResetFilter();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorTextPrimary,
              ),
            ),
            const SizedBox(height: 16),

            CustomSearchableDropdown<String>(
              value: _filterType,
              items: widget.filterTypes,
              itemLabel: (v) => _kFilterTypeLabels[v] ?? v,
              onChanged: (val) => setState(() => _filterType = val ?? 'today'),
              label: 'Filter By',
              hintText: 'Select filter type',
              clearable: false,
            ),

            const SizedBox(height: 16),

            if (_filterType == 'custom') ...[
              const FilterSectionLabel('Custom Date *'),
              FilterDatePickerBox(value: _customDate, onTap: _pickCustomDate),
            ],

            if (_filterType == 'end_of_month')
              Row(
                children: [
                  Expanded(
                    child: CustomSearchableDropdown<int>(
                      label: 'Month *',
                      value: _month,
                      items: List.generate(12, (i) => i + 1),
                      itemLabel: (m) => _kMonthNames[m - 1],
                      onChanged: (val) => setState(() => _month = val),
                      hintText: 'Month',
                      clearable: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: CustomSearchableDropdown<int>(
                      label: 'Year',
                      value: _monthYear,
                      items: _yearOptions,
                      itemLabel: (y) => y.toString(),
                      onChanged: (val) => setState(
                          () => _monthYear = val ?? DateTime.now().year),
                      hintText: 'Year',
                      clearable: false,
                    ),
                  ),
                ],
              ),

            if (_filterType == 'end_of_quarter') ...[
              CustomSearchableDropdown<String>(
                value: _quarter,
                items: const ['Q1', 'Q2', 'Q3', 'Q4'],
                itemLabel: (v) => _kQuarterLabels[v] ?? v,
                onChanged: (val) => setState(() => _quarter = val ?? 'Q1'),
                label: 'Quarter',
                hintText: 'Select quarter',
                clearable: false,
              ),
              const SizedBox(height: 14),
              CustomSearchableDropdown<int>(
                value: _year,
                items: _yearOptions,
                itemLabel: (y) => y.toString(),
                onChanged: (val) =>
                    setState(() => _year = val ?? DateTime.now().year),
                label: 'Year',
                hintText: 'Select year',
                clearable: false,
              ),
            ],

            if (_filterType == 'end_of_year')
              CustomSearchableDropdown<int>(
                value: _year,
                items: _yearOptions,
                itemLabel: (y) => y.toString(),
                onChanged: (val) =>
                    setState(() => _year = val ?? DateTime.now().year),
                label: 'Year',
                hintText: 'Select year',
                clearable: false,
              ),

            const SizedBox(height: 20),

            FilterActionButtons(onReset: _onReset, onApply: _onApply),
          ],
        ),
      ),
    );
  }
}

class DateRangeFilterSheet extends StatefulWidget {
  final String title;
  final DateTime? initialDateFrom;
  final DateTime? initialDateTo;
  final void Function(DateTime?, DateTime?) onSetDateRange;
  final VoidCallback onApplyFilter;
  final VoidCallback onResetFilter;

  const DateRangeFilterSheet({
    super.key,
    required this.title,
    required this.initialDateFrom,
    required this.initialDateTo,
    required this.onSetDateRange,
    required this.onApplyFilter,
    required this.onResetFilter,
  });

  @override
  State<DateRangeFilterSheet> createState() => _DateRangeFilterSheetState();
}

class _DateRangeFilterSheetState extends State<DateRangeFilterSheet> {
  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    _dateFrom = widget.initialDateFrom;
    _dateTo = widget.initialDateTo;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await pickFilterDate(
      context,
      initial: isFrom ? _dateFrom : _dateTo,
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
        }
      });
    }
  }

  void _warn(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: colorError),
    );
  }

  void _onApply() {
    if (_dateFrom == null) {
      _warn('From Date is required!');
      return;
    }
    if (_dateTo == null) {
      _warn('To Date is required!');
      return;
    }
    if (_dateFrom!.isAfter(_dateTo!)) {
      _warn('From Date cannot be later than To Date!');
      return;
    }

    widget.onSetDateRange(_dateFrom, _dateTo);
    widget.onApplyFilter();
    Navigator.pop(context);
  }

  void _onReset() {
    widget.onResetFilter();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorTextPrimary,
              ),
            ),
            const SizedBox(height: 16),
            FilterDateRangeRow(
              fromLabel: 'From Date *',
              toLabel: 'To Date *',
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              onTapFrom: () => _pickDate(isFrom: true),
              onTapTo: () => _pickDate(isFrom: false),
            ),
            const SizedBox(height: 20),
            FilterActionButtons(onReset: _onReset, onApply: _onApply),
          ],
        ),
      ),
    );
  }
}