import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/data/models/location_report_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/presentation/controllers/location_report_controller.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class LocationReportDetailScreen extends StatefulWidget {
  final String encryption;
  const LocationReportDetailScreen({super.key, required this.encryption});

  @override
  State<LocationReportDetailScreen> createState() =>
      _LocationReportDetailScreenState();
}

class _LocationReportDetailScreenState extends State<LocationReportDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  late final LocationReportController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = context.read<LocationReportController>();
    _tab = TabController(length: LocationDetailType.values.length, vsync: this);
    _tab.addListener(() {
      if (_tab.indexIsChanging) return;
      _ctrl.ensureTabLoaded(LocationDetailType.values[_tab.index]);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _ctrl.fetchReportDetail(widget.encryption);
      if (mounted && _ctrl.reportDetail != null) {
        _ctrl.ensureTabLoaded(LocationDetailType.values[_tab.index]);
      }
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    _ctrl.resetDetailState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Location Detail",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<LocationReportController>(
        builder: (context, ctrl, child) {
          if (ctrl.isLoadingDetail) {
            return const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            );
          }
          if (ctrl.detailError != null) {
            return Center(
              child: Text(
                ctrl.detailError!,
                style: GoogleFonts.poppins(color: colorError),
              ),
            );
          }
          final detail = ctrl.reportDetail;
          if (detail == null) return const SizedBox.shrink();

          final s = detail.summary;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildHeaderCard(detail),
              ),
              Container(
                color: colorWhite,
                child: TabBar(
                  controller: _tab,
                  isScrollable: true,
                  labelColor: colorPrimary,
                  unselectedLabelColor: colorTextSubtle,
                  indicatorColor: colorPrimary,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: 'Products (${s.product})'),
                    Tab(text: 'Child (${s.child})'),
                    Tab(text: 'Receipts (${s.receipt})'),
                    Tab(text: 'Deliveries (${s.delivery})'),
                    Tab(text: 'Transfers (${s.transfer})'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    _PagedTab<LocationStockModel>(
                      type: LocationDetailType.products,
                      state: ctrl.products,
                      emptyText: 'No product stock',
                      itemBuilder: _stockTile,
                    ),
                    _PagedTab<LocationChildModel>(
                      type: LocationDetailType.children,
                      state: ctrl.children,
                      emptyText: 'No child location',
                      itemBuilder: _childTile,
                    ),
                    _PagedTab<LocationNoteModel>(
                      type: LocationDetailType.receipts,
                      state: ctrl.receipts,
                      emptyText: 'No receipt note',
                      itemBuilder: _noteTile,
                    ),
                    _PagedTab<LocationNoteModel>(
                      type: LocationDetailType.deliveries,
                      state: ctrl.deliveries,
                      emptyText: 'No delivery note',
                      itemBuilder: _noteTile,
                    ),
                    _PagedTab<LocationTransferModel>(
                      type: LocationDetailType.transfers,
                      state: ctrl.transfers,
                      emptyText: 'No internal transfer',
                      itemBuilder: _transferTile,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(LocationReportDetailModel detail) {
    return Card(
      color: colorCard,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.locationName,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              detail.locationCode,
              style: GoogleFonts.roboto(fontSize: 13, color: colorTextSubtle),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: colorGreyLight),
            const SizedBox(height: 12),
            _infoRow('Warehouse', detail.warehouseName ?? '-'),
            const SizedBox(height: 6),
            _infoRow('Parent Location', detail.parentName ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 13),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tile({required Widget child}) {
    return Card(
      color: colorCard,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }

  Widget _stockTile(LocationStockModel s) {
    return _tile(
      child: Row(
        children: [
          Expanded(
            child: Text(
              s.productName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Stock: ${s.stockQty.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: colorTextSubtle,
                ),
              ),
              Text(
                'Reserved: ${s.reservedQty.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: colorTextSubtle,
                ),
              ),
              Text(
                'On Hand: ${s.onHand.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _childTile(LocationChildModel c) {
    return _tile(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.locationName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  c.locationCode,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: colorTextSubtle,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${c.totalProduct} product',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: colorPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteTile(LocationNoteModel n) {
    return _tile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  n.reference,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              _statusChip(n.status),
            ],
          ),
          const SizedBox(height: 6),
          _infoRow('Scheduled', _fmtDate(n.scheduledDate)),
          const SizedBox(height: 2),
          _infoRow('Transfer Date', _fmtDate(n.dateOfTransfer)),
          const SizedBox(height: 2),
          _infoRow('Source Doc', n.sourceDocument),
        ],
      ),
    );
  }

  Widget _transferTile(LocationTransferModel t) {
    return _tile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.reference,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              _statusChip(t.status),
            ],
          ),
          const SizedBox(height: 6),
          _infoRow('From', t.sourceName),
          const SizedBox(height: 2),
          _infoRow('To', t.destinationName),
          const SizedBox(height: 2),
          _infoRow('Scheduled', _fmtDate(t.scheduledDate)),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    final k = status.toLowerCase();
    if (['done', 'paid', 'success', 'completed', 'active', 'posted']
        .contains(k)) {
      return Colors.green;
    }
    if (['partial', 'ongoing', 'processing', 'confirmed'].contains(k)) {
      return Colors.blue;
    }
    if (['unpaid', 'cancelled', 'canceled', 'failed', 'rejected', 'closed']
        .contains(k)) {
      return colorError;
    }
    if (['waiting approval', 'pending', 'waiting'].contains(k)) {
      return Colors.orange;
    }
    return colorGrey;
  }

  String _fmtDate(String? raw) {
    final d = raw == null ? null : DateTime.tryParse(raw);
    if (d == null) return '-';
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class _PagedTab<T> extends StatelessWidget {
  final LocationDetailType type;
  final LocationTabState<T> state;
  final String emptyText;
  final Widget Function(T item) itemBuilder;

  const _PagedTab({
    required this.type,
    required this.state,
    required this.emptyText,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<LocationReportController>();

    Widget body;
    if (state.isLoading) {
      body = const Center(child: CircularProgressIndicator(color: colorPrimary));
    } else if (state.error != null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: colorError),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ctrl.fetchTab(type),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: colorWhite,
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    } else if (state.items.isEmpty) {
      body = Center(
        child: Text(
          emptyText,
          style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 13),
        ),
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.items.length,
        itemBuilder: (_, i) => itemBuilder(state.items[i]),
      );
    }

    return Column(
      children: [
        Expanded(child: body),
        PaginationBottomBar(
          currentPage: state.page,
          lastPage: state.lastPage,
          hasPrev: state.hasPrev,
          hasNext: state.hasNext,
          onGoToPage: (p) => ctrl.goToTabPage(type, p),
          onPrev: () => ctrl.goToTabPage(type, state.page - 1),
          onNext: () => ctrl.goToTabPage(type, state.page + 1),
        ),
      ],
    );
  }
}