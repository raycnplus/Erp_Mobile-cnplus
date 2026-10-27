double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '-';
String? _pn(dynamic v) => v?.toString();

class BillingTaxRow {
  final int id;
  final String invoiceType;
  final String reference;
  final String customer;
  final String address;
  final String npwp;
  final String project;
  final String poNumber;
  final String? poDate;
  final String termName;
  final double untaxedAmount;
  final double totalTaxes;
  final double grandTotal;
  final String? invoiceDate;
  final String? year;
  final String fakturPajak;
  final String? tanggalFakturPajak;
  final String? vatPaymentDate;
  final double totalPph23;
  final String eBupot;
  final String? eBupotDate;
  final String eBupotCutterName;
  final String eBupotCutterAddress;
  final String eBupotSignerName;
  final double amountPaid;
  final String? paymentDate;
  final String bpeNumber;
  final String? bpeDate;
  final String taxBillingNumber;
  final String? taxBillingPaymentDate;
  final String taxBillingSignerName;
  final String taxPaymentStatus;
  final String status;

  BillingTaxRow({
    required this.id,
    required this.invoiceType,
    required this.reference,
    required this.customer,
    required this.address,
    required this.npwp,
    required this.project,
    required this.poNumber,
    this.poDate,
    required this.termName,
    required this.untaxedAmount,
    required this.totalTaxes,
    required this.grandTotal,
    this.invoiceDate,
    this.year,
    required this.fakturPajak,
    this.tanggalFakturPajak,
    this.vatPaymentDate,
    required this.totalPph23,
    required this.eBupot,
    this.eBupotDate,
    required this.eBupotCutterName,
    required this.eBupotCutterAddress,
    required this.eBupotSignerName,
    required this.amountPaid,
    this.paymentDate,
    required this.bpeNumber,
    this.bpeDate,
    required this.taxBillingNumber,
    this.taxBillingPaymentDate,
    required this.taxBillingSignerName,
    required this.taxPaymentStatus,
    required this.status,
  });

  factory BillingTaxRow.fromJson(Map<String, dynamic> j) => BillingTaxRow(
        id:                    _pi(j['id']),
        invoiceType:           _ps(j['invoice_type']),
        reference:             _ps(j['reference']),
        customer:              _ps(j['customer']),
        address:               _ps(j['address']),
        npwp:                  _ps(j['npwp']),
        project:               _ps(j['project']),
        poNumber:              _ps(j['po_number']),
        poDate:                _pn(j['po_date']),
        termName:              _ps(j['term_name']),
        untaxedAmount:         _pd(j['untaxed_amount']),
        totalTaxes:            _pd(j['total_taxes']),
        grandTotal:            _pd(j['grand_total']),
        invoiceDate:           _pn(j['invoice_date']),
        year:                  _pn(j['year']),
        fakturPajak:           _ps(j['faktur_pajak']),
        tanggalFakturPajak:    _pn(j['tanggal_faktur_pajak']),
        vatPaymentDate:        _pn(j['vat_payment_date']),
        totalPph23:            _pd(j['total_pph23']),
        eBupot:                _ps(j['e_bupot']),
        eBupotDate:            _pn(j['e_bupot_date']),
        eBupotCutterName:      _ps(j['e_bupot_cutter_name']),
        eBupotCutterAddress:   _ps(j['e_bupot_cutter_address']),
        eBupotSignerName:      _ps(j['e_bupot_signer_name']),
        amountPaid:            _pd(j['amount_paid']),
        paymentDate:           _pn(j['payment_date']),
        bpeNumber:             _ps(j['bpe_number']),
        bpeDate:               _pn(j['bpe_date']),
        taxBillingNumber:      _ps(j['tax_billing_number']),
        taxBillingPaymentDate: _pn(j['tax_billing_payment_date']),
        taxBillingSignerName:  _ps(j['tax_billing_signer_name']),
        taxPaymentStatus:      _ps(j['tax_payment_status']),
        status:                _ps(j['status']),
      );
}

class BillingTaxSummary {
  final double totalUntaxed;
  final double totalTaxes;
  final double totalGrand;

  BillingTaxSummary({
    required this.totalUntaxed,
    required this.totalTaxes,
    required this.totalGrand,
  });

  factory BillingTaxSummary.fromJson(Map<String, dynamic> j) => BillingTaxSummary(
        totalUntaxed: _pd(j['total_untaxed']),
        totalTaxes:   _pd(j['total_taxes']),
        totalGrand:   _pd(j['total_grand']),
      );
}

class BillingTaxFilters {
  final int? year;
  final int? month;
  final int? customerId;

  BillingTaxFilters({this.year, this.month, this.customerId});

  factory BillingTaxFilters.fromJson(Map<String, dynamic> j) => BillingTaxFilters(
        year:       j['year'] == null ? null : _pi(j['year']),
        month:      j['month'] == null ? null : _pi(j['month']),
        customerId: j['customer_id'] == null ? null : _pi(j['customer_id']),
      );
}

class BillingTaxPage {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  final List<BillingTaxRow> rows;

  BillingTaxPage({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    required this.rows,
  });

  factory BillingTaxPage.fromJson(Map<String, dynamic> j) => BillingTaxPage(
        currentPage: _pi(j['current_page']),
        lastPage:    _pi(j['last_page']),
        total:       _pi(j['total']),
        perPage:     _pi(j['per_page']),
        rows: (j['data'] as List? ?? [])
            .map((e) => BillingTaxRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPrevPage => currentPage > 1;
}

class BillingTaxResult {
  final BillingTaxFilters filters;
  final BillingTaxSummary summary;
  final BillingTaxPage page;

  BillingTaxResult({required this.filters, required this.summary, required this.page});

  factory BillingTaxResult.fromJson(Map<String, dynamic> json) => BillingTaxResult(
        filters: BillingTaxFilters.fromJson(json['filters'] as Map<String, dynamic>? ?? {}),
        summary: BillingTaxSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
        page:    BillingTaxPage.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
      );
}

class BillingTaxCustomerOption {
  final int idCustomer;
  final String customerName;

  BillingTaxCustomerOption({required this.idCustomer, required this.customerName});

  factory BillingTaxCustomerOption.fromJson(Map<String, dynamic> j) => BillingTaxCustomerOption(
        idCustomer:   _pi(j['id_customer']),
        customerName: _ps(j['customer_name']),
      );

  @override bool operator ==(Object o) => o is BillingTaxCustomerOption && o.idCustomer == idCustomer;
  @override int get hashCode => idCustomer.hashCode;
}

class BillingTaxFormOptions {
  final List<BillingTaxCustomerOption> customers;

  BillingTaxFormOptions({required this.customers});

  factory BillingTaxFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BillingTaxFormOptions(
      customers: (data['customers'] as List? ?? [])
          .map((e) => BillingTaxCustomerOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}