import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/presentation/controllers/delivery_note_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/models/delivery_note_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

Future<List<Map<String, dynamic>>?> showDeliveryNoteTrackingDialog({
  required BuildContext context,
  required DeliveryNoteItem item,
  required int? sourceLocation,
  required List<Map<String, dynamic>> initialTracking,
  bool readOnly = false,
}) {
  return showDialog<List<Map<String, dynamic>>>(
    context: context,
    builder: (_) => _TrackingDialog(
      item: item,
      sourceLocation: sourceLocation,
      initialTracking: initialTracking,
      readOnly: readOnly,
    ),
  );
}

class _TrackingDialog extends StatefulWidget {
  final DeliveryNoteItem item;
  final int? sourceLocation;
  final List<Map<String, dynamic>> initialTracking;
  final bool readOnly;

  const _TrackingDialog({
    required this.item,
    required this.sourceLocation,
    required this.initialTracking,
    required this.readOnly,
  });

  @override
  State<_TrackingDialog> createState() => _TrackingDialogState();
}

class _TrackingDialogState extends State<_TrackingDialog> {
  late List<Map<String, dynamic>> _rows;
  List<DeliveryNoteLotSerial> _availableLots = [];
  bool _isLoadingLots = false;
  bool _lotsFetchAttempted = false;
  String? _lotsFetchError;

  double get _totalQty => _rows.fold(0, (s, r) => s + (r['quantity'] as double));

  @override
  void initState() {
    super.initState();
    _rows = widget.initialTracking.map((r) => Map<String, dynamic>.from(r)).toList();
    if (!widget.readOnly) {
      _fetchAvailableLots();
    }
  }

  Future<void> _fetchAvailableLots() async {
    if (widget.sourceLocation == null || _isLoadingLots) return;
    final ctrl = context.read<DeliveryNoteController>();
    setState(() {
      _isLoadingLots = true;
      _lotsFetchError = null;
    });
    try {
      final res = await ctrl.lotSerialsSorted(widget.item.idProduct, widget.sourceLocation!);
      final list = (res['lot_serials'] as List? ?? [])
          .map((e) => DeliveryNoteLotSerial.fromJson(e as Map<String, dynamic>))
          .toList();
      if (mounted) setState(() => _availableLots = list);
    } catch (e) {
      if (mounted) setState(() => _lotsFetchError = 'Failed to load lot/serial numbers');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLots = false;
          _lotsFetchAttempted = true;
        });
      }
    }
  }

  void _addRow() {
    final remaining = widget.item.demandQty - _totalQty;
    if (remaining <= 0) return;
    setState(() {
      _rows.add({'id_product_lot_serial': null, 'lot_number': '', 'quantity': 0.0});
    });
  }

  Future<void> _autoSelect() async {
    if (_availableLots.isEmpty && !_lotsFetchAttempted) {
      await _fetchAvailableLots();
    }
    if (_availableLots.isEmpty) return;

    double remaining = widget.item.demandQty;
    final newRows = <Map<String, dynamic>>[];

    for (final lot in _availableLots) {
      if (remaining <= 0) break;
      if (lot.remainingQuantity <= 0) continue;
      final qty = remaining < lot.remainingQuantity ? remaining : lot.remainingQuantity;
      newRows.add({
        'id_product_lot_serial': lot.idProductLotSerial,
        'lot_number': lot.lotSerialNumber ?? '',
        'quantity': qty,
      });
      remaining -= qty;
    }

    setState(() => _rows = newRows);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tracking Detail', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(
                widget.item.productName ?? '',
                style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
              ),
              Text(
                'Demand: ${widget.item.demandQty.toStringAsFixed(2)}   Total selected: ${_totalQty.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: _totalQty > widget.item.demandQty ? colorError : colorTextSubtle,
                ),
              ),
              if (_lotsFetchError != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.error_outline, size: 14, color: colorError),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(_lotsFetchError!, style: GoogleFonts.poppins(fontSize: 11, color: colorError)),
                    ),
                    TextButton(
                      onPressed: _isLoadingLots ? null : _fetchAvailableLots,
                      child: Text('Retry', style: GoogleFonts.poppins(fontSize: 11)),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Flexible(
                child: _rows.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('No tracking entries', style: GoogleFonts.poppins(color: colorGrey)),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _rows.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _buildRow(i),
                      ),
              ),
              const SizedBox(height: 10),
              if (!widget.readOnly)
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _addRow,
                      icon: const Icon(Icons.add, size: 16),
                      label: Text('Add', style: GoogleFonts.poppins(fontSize: 12)),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isLoadingLots ? null : _autoSelect,
                      icon: _isLoadingLots
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.auto_fix_high, size: 16),
                      label: Text('Auto', style: GoogleFonts.poppins(fontSize: 12)),
                    ),
                    OutlinedButton.icon(
                      onPressed: _rows.isEmpty ? null : () => setState(() => _rows = []),
                      icon: const Icon(Icons.clear_all, size: 16),
                      label: Text('Clear', style: GoogleFonts.poppins(fontSize: 12)),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close', style: GoogleFonts.poppins(color: colorGreyDark)),
                  ),
                  if (!widget.readOnly) ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _rows.isEmpty
                          ? null
                          : () {
                              final incomplete = _rows.any((r) =>
                                  r['id_product_lot_serial'] == null || (r['quantity'] as double) <= 0);
                              if (incomplete) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Complete all rows before saving'),
                                  backgroundColor: colorError,
                                ));
                                return;
                              }
                              Navigator.pop(context, _rows);
                            },
                      style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                      child: Text('Save', style: GoogleFonts.poppins()),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(int i) {
    final row = _rows[i];

    if (widget.readOnly) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(row['lot_number']?.toString() ?? '-', style: GoogleFonts.poppins(fontSize: 13)),
        trailing: Text(
          (row['quantity'] as double).toStringAsFixed(2),
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            value: row['id_product_lot_serial'] as int?,
            isExpanded: true,
            decoration: InputDecoration(
              isDense: true,
              labelText: _isLoadingLots ? 'Loading...' : 'Lot/Serial',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            items: _availableLots
                .map((l) => DropdownMenuItem(
                      value: l.idProductLotSerial,
                      child: Text(
                        l.lotSerialNumber ?? '-',
                        style: GoogleFonts.poppins(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: _isLoadingLots
                ? null
                : (v) {
                    final lot = _availableLots.firstWhere((l) => l.idProductLotSerial == v);
                    setState(() {
                      row['id_product_lot_serial'] = v;
                      row['lot_number'] = lot.lotSerialNumber ?? '';
                    });
                  },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: (row['quantity'] as double) > 0 ? (row['quantity'] as double).toStringAsFixed(2) : '',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Qty',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onChanged: (v) => row['quantity'] = double.tryParse(v) ?? 0.0,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: colorError, size: 18),
          onPressed: () => setState(() => _rows.removeAt(i)),
        ),
      ],
    );
  }
}