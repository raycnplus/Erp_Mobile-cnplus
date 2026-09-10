double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int? _pi(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

String _ps(dynamic v) => v?.toString() ?? '';

class ARAgingRow {
  final int? sourceId;
  final String invoiceType;
  final String reference;
  final String customerName;
  final String? invoiceDate;
  final String? dueDate;
  final double invoiceAmount;
  final double paidAmount;
  final double outstanding;
  final String? paymentDate;
  final String? paymentNumber;
  final int? daysOverdue;
  final String agingBucket;
  final String statusLabel;

  ARAgingRow({
    this.sourceId,
    required this.invoiceType,
    required this.reference,
    required this.customerName,
    this.invoiceDate,
    this.dueDate,
    required this.invoiceAmount,
    required this.paidAmount,
    required this.outstanding,
    this.paymentDate,
    this.paymentNumber,
    this.daysOverdue,
    required this.agingBucket,
    required this.statusLabel,
  });

  factory ARAgingRow.fromJson(Map<String, dynamic> j) => ARAgingRow(
        sourceId:      _pi(j['source_id']),
        invoiceType:   _ps(j['invoice_type']),
        reference:     _ps(j['reference']),
        customerName:  _ps(j['customer_name']),
        invoiceDate:   j['invoice_date']?.toString(),
        dueDate:       j['due_date']?.toString(),
        invoiceAmount: _pd(j['invoice_amount']),
        paidAmount:    _pd(j['paid_amount']),
        outstanding:   _pd(j['outstanding']),
        paymentDate:   j['payment_date']?.toString(),
        paymentNumber: j['payment_number']?.toString(),
        daysOverdue:   _pi(j['days_overdue']),
        agingBucket:   _ps(j['aging_bucket']),
        statusLabel:   _ps(j['status_label']),
      );

  bool get isPaid => statusLabel == 'Paid';
  bool get isOverdue => statusLabel == 'Overdue';
}

class ARAgingSummary {
  final double current;
  final double days30;
  final double days60;
  final double days90;
  final double over90;
  final double total;

  ARAgingSummary({
    required this.current,
    required this.days30,
    required this.days60,
    required this.days90,
    required this.over90,
    required this.total,
  });

  factory ARAgingSummary.fromJson(Map<String, dynamic> j) => ARAgingSummary(
        current: _pd(j['current']),
        days30:  _pd(j['days_30']),
        days60:  _pd(j['days_60']),
        days90:  _pd(j['days_90']),
        over90:  _pd(j['over_90']),
        total:   _pd(j['total']),
      );
}

class ARAgingTotals {
  final double invoiceAmount;
  final double paidAmount;
  final double outstanding;

  ARAgingTotals({
    required this.invoiceAmount,
    required this.paidAmount,
    required this.outstanding,
  });

  factory ARAgingTotals.fromJson(Map<String, dynamic> j) => ARAgingTotals(
        invoiceAmount: _pd(j['invoice_amount']),
        paidAmount:    _pd(j['paid_amount']),
        outstanding:   _pd(j['outstanding']),
      );
}

class ARAgingFilters {
  final String? dateFrom;
  final String? dateTo;
  final String? asOfDate;
  final int? customerId;
  final String viewType;

  ARAgingFilters({
    this.dateFrom,
    this.dateTo,
    this.asOfDate,
    this.customerId,
    required this.viewType,
  });

  factory ARAgingFilters.fromJson(Map<String, dynamic> j) => ARAgingFilters(
        dateFrom:   j['date_from']?.toString(),
        dateTo:     j['date_to']?.toString(),
        asOfDate:   j['as_of_date']?.toString(),
        customerId: _pi(j['customer_id']),
        viewType:   _ps(j['view_type']).isEmpty ? 'receivable' : _ps(j['view_type']),
      );
}

class ARAgingResult {
  final ARAgingFilters filters;
  final ARAgingSummary summary;
  final ARAgingTotals totals;
  final List<ARAgingRow> rows;

  ARAgingResult({
    required this.filters,
    required this.summary,
    required this.totals,
    required this.rows,
  });

  factory ARAgingResult.fromJson(Map<String, dynamic> json) => ARAgingResult(
        filters: ARAgingFilters.fromJson(json['filters'] as Map<String, dynamic>? ?? {}),
        summary: ARAgingSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
        totals:  ARAgingTotals.fromJson(json['totals'] as Map<String, dynamic>? ?? {}),
        rows: (json['data'] as List? ?? [])
            .map((e) => ARAgingRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class ARAgingCustomerOption {
  final int idCustomer;
  final String customerName;

  ARAgingCustomerOption({required this.idCustomer, required this.customerName});

  factory ARAgingCustomerOption.fromJson(Map<String, dynamic> j) => ARAgingCustomerOption(
        idCustomer:   _pi(j['id_customer']) ?? 0,
        customerName: _ps(j['customer_name']),
      );

  @override bool operator ==(Object o) => o is ARAgingCustomerOption && o.idCustomer == idCustomer;
  @override int get hashCode => idCustomer.hashCode;
}

class ARAgingFormOptions {
  final List<ARAgingCustomerOption> customers;
  final List<String> viewTypes;

  ARAgingFormOptions({required this.customers, required this.viewTypes});

  factory ARAgingFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ARAgingFormOptions(
      customers: (data['customers'] as List? ?? [])
          .map((e) => ARAgingCustomerOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewTypes: (data['view_types'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}