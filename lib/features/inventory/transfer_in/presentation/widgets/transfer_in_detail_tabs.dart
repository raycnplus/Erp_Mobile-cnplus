import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/models/transfer_in_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/presentation/widgets/transfer_in_tracking_dialog.dart';

class TransferInDetailTabs extends StatefulWidget {
  final TransferInDetailModel detail;
  final List<TransferInFormItem> formItems;
  final bool isEditing;
  final Map<int, TextEditingController> qtyControllers;

  const TransferInDetailTabs({
    super.key,
    required this.detail,
    required this.formItems,
    required this.isEditing,
    required this.qtyControllers,
  });

  @override
  State<TransferInDetailTabs> createState() => _State();
}

class _State extends State<TransferInDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _fmt(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('d MMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtDt(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('d MMM yyyy, HH:mm').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  static const _statusColors = <String, Color>{
    'Confirmed': Color(0xFF1565C0),
    'Done':      Color(0xFF2E7D32),
    'Cancelled': Color(0xFFC62828),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final steps = (status == 'Cancelled') ? ['Confirmed', status] : ['Confirmed', 'Done'];
    int activeIdx = steps.indexOf(status);
    if (activeIdx < 0) activeIdx = 0;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final passed = (i ~/ 2) < activeIdx;
            return Expanded(child: Container(height: 2, color: passed ? colorPrimary : colorGreyLight));
          }
          final idx = i ~/ 2;
          final isDone = idx < activeIdx;
          final isCurrent = idx == activeIdx;
          final label = steps[idx];

          Color dot = colorGreyLight;
          if (isCurrent) dot = _statusColors[label] ?? colorPrimary;
          else if (isDone) dot = colorPrimary;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDone || isCurrent) ? dot : Colors.white,
                  border: Border.all(color: (isDone || isCurrent) ? dot : colorGreyLight, width: 2),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : isCurrent
                          ? const Icon(Icons.circle, size: 10, color: Colors.white)
                          : null,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 56,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.normal,
                    color: isCurrent ? dot : isDone ? colorPrimary : colorGrey,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return Column(
      children: [
        _buildPipeline(),
        if (d.hasEmptyTransferredQty)
          Container(
            width: double.infinity,
            color: Colors.orange.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.orange.shade800),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'This Transfer In cannot be processed yet, one or more products are still waiting for the Transfer Out to be validated first.',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.orange.shade800),
                  ),
                ),
              ],
            ),
          ),
        const Divider(height: 1, thickness: 1, color: colorGreyLight),
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Info'),
            Tab(text: 'Logs'),
            Tab(text: 'Others'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildProductsTab(d),
              _buildInfoTab(d),
              AuditTrailList(
                items: d.auditTrails
                    .map((a) => AuditTrailItem(
                          actionByName: a.actionByName,
                          actionById: a.actionById,
                          date: a.date,
                          description: a.description,
                        ))
                    .toList(),
              ),
              _buildOthersTab(d),
            ],
          ),
        ),
      ],
    );
  }

  TextEditingController _ctrlFor(int mappingKey, double? value) {
    return widget.qtyControllers.putIfAbsent(
      mappingKey,
      () => TextEditingController(text: value != null ? value.toStringAsFixed(2) : ''),
    );
  }

  Widget _buildProductsTab(TransferInDetailModel d) {
    if (widget.formItems.isEmpty) {
      return Center(child: Text('No products', style: GoogleFonts.poppins(color: colorGrey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.formItems.length,
      itemBuilder: (_, i) {
        final item = widget.formItems[i];
        final isShort = item.receivedQty != null && item.transferredQty != null && item.receivedQty! < item.transferredQty!;
        final hasTracking = d.hasTrackingFor(item.idProduct) && (d.isConfirmed || d.isDone);

        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        item.productName ?? '-',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
                      ),
                    ),
                    if (hasTracking)
                      IconButton(
                        onPressed: () {
                          final entry = d.lotSerialsPerItem[item.idProduct.toString()];
                          final lotSerials = ((entry?['lot_serials'] as List?) ?? [])
                              .map((e) => TILotSerial.fromJson(Map<String, dynamic>.from(e)))
                              .toList();
                          final usages = ((entry?['usage'] as List?) ?? [])
                              .map((e) => TITrackingUsage.fromJson(Map<String, dynamic>.from(e)))
                              .toList();
                          showTransferInTrackingDialog(
                            context: context,
                            productName: item.productName ?? '-',
                            uom: item.uomName ?? '',
                            lotSerials: lotSerials,
                            usages: usages,
                          );
                        },
                        icon: const Icon(Icons.list_alt_outlined, color: colorPrimary, size: 20),
                        tooltip: 'View Tracking',
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transferred Qty', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
                          Text(
                            item.transferredQty != null ? '${_fmtNum(item.transferredQty!)} ${item.uomName ?? ''}' : '-',
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: colorTextPrimary),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Received Qty', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
                          const SizedBox(height: 4),
                          widget.isEditing
                              ? TextField(
                                  controller: _ctrlFor(item.mappingKey, item.receivedQty),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onChanged: (v) => item.receivedQty = double.tryParse(v),
                                )
                              : Text(
                                  item.receivedQty != null ? '${_fmtNum(item.receivedQty!)} ${item.uomName ?? ''}' : '-',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isShort ? Colors.orange.shade700 : colorPrimary,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTab(TransferInDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Transfer In Info', Icons.download_outlined, [
            _row('Reference', _safe(d.reference)),
            _row('Status', d.status),
            _row('Source Warehouse', _safe(d.sourceWarehouseName)),
            _row('Source Location', _safe(d.sourceLocationName)),
            _row('Destination Warehouse', _safe(d.destinationWarehouseName)),
            _row('Destination Location', _safe(d.destinationLocationName)),
            _row('Scheduled Date', _fmt(d.scheduledDate)),
            if (d.sourceDocument?.isNotEmpty == true) _row('Source Document', d.sourceDocument!),
            if (d.notes?.isNotEmpty == true) _row('Notes', d.notes!),
          ]),
        ],
      ),
    );
  }

  Widget _buildOthersTab(TransferInDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Creation', Icons.add_circle_outline_outlined, [
            _row('Created By', _safe(d.createdByName)),
            if (d.createdDate?.isNotEmpty == true) _row('Created On', _fmtDt(d.createdDate)),
          ]),
          if (d.updatedByName?.isNotEmpty == true || d.updatedDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Last Update', Icons.update_outlined, [
              if (d.updatedByName?.isNotEmpty == true) _row('Updated By', _safe(d.updatedByName)),
              if (d.updatedDate?.isNotEmpty == true) _row('Updated On', _fmtDt(d.updatedDate)),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 150, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );

  Widget _infoCard(String title, IconData icon, List<Widget> rows) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: colorCard,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: colorPrimary, size: 18),
                  const SizedBox(width: 8),
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorTextPrimary)),
                ],
              ),
              const Divider(height: 16),
              ...rows,
            ],
          ),
        ),
      );
}