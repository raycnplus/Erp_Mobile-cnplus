import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/models/receipt_note_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/controllers/receipt_note_controller.dart';

class _TrackingLine {
  final TextEditingController lotCtrl;
  final TextEditingController qtyCtrl;
  final String? idProductLotSerial;
  DateTime? expirationDate;
  DateTime? removalDate;

  _TrackingLine({
    required this.lotCtrl,
    required this.qtyCtrl,
    this.idProductLotSerial,
    this.expirationDate,
    this.removalDate,
  });

  void dispose() {
    lotCtrl.dispose();
    qtyCtrl.dispose();
  }
}

class ReceiptNoteTrackingDialog extends StatefulWidget {
  final ReceiptNoteItem item;
  final String status;
  final bool isViewMode;

  const ReceiptNoteTrackingDialog({
    super.key,
    required this.item,
    required this.status,
    this.isViewMode = false,
  });

  @override
  State<ReceiptNoteTrackingDialog> createState() => _ReceiptNoteTrackingDialogState();
}

class _ReceiptNoteTrackingDialogState extends State<ReceiptNoteTrackingDialog> {
  final List<_TrackingLine> _lines = [];
  ReceiptNoteInventorySettings? _settings;
  bool _loadingSettings = true;
  bool _showGenerateForm = false;
  bool _saving = false;

  final _firstLotCtrl = TextEditingController();
  final _qtyPerLotCtrl = TextEditingController(text: '1');
  bool _keepCurrentLines = false;

  bool get _isSerial => widget.item.trackingMethod == 'serial_number';
  bool get _isDone => widget.status == 'Done';
  bool get _readOnly => _isDone || widget.isViewMode;

  @override
  void initState() {
    super.initState();
    for (final t in widget.item.trackingData) {
      _lines.add(_TrackingLine(
        lotCtrl: TextEditingController(text: t.lotNumber),
        qtyCtrl: TextEditingController(text: t.remainingQuantity.toStringAsFixed(0)),
        idProductLotSerial: t.idProductLotSerial == 0 ? null : t.idProductLotSerial.toString(),
      ));
    }
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final ctrl = context.read<ReceiptNoteController>();
    final s = await ctrl.fetchInventorySettings(widget.item.idProduct);
    if (!mounted) return;
    setState(() {
      _settings = s;
      _loadingSettings = false;
    });
  }

  @override
  void dispose() {
    for (final l in _lines) {
      l.dispose();
    }
    _firstLotCtrl.dispose();
    _qtyPerLotCtrl.dispose();
    super.dispose();
  }

  double get _totalQty {
    double sum = 0;
    for (final l in _lines) {
      sum += double.tryParse(l.qtyCtrl.text) ?? 0;
    }
    return sum;
  }

  bool get _canAddLine => _totalQty < widget.item.demandQty;

  ({String prefix, String suffix, int digitCount, int numericPart}) _extractLotFormat(String lot) {
    final match = RegExp(r'^([^0-9]*?)(\d+)([^0-9]*)$').firstMatch(lot);
    if (match == null) {
      return (prefix: lot, suffix: '', digitCount: 0, numericPart: 0);
    }
    return (
      prefix: match.group(1) ?? '',
      suffix: match.group(3) ?? '',
      digitCount: (match.group(2) ?? '').length,
      numericPart: int.tryParse(match.group(2) ?? '0') ?? 0,
    );
  }

  String _formatLotNumber(String prefix, int number, int digitCount, String suffix) {
    var result = prefix;
    if (digitCount > 0) result += number.toString().padLeft(digitCount, '0');
    return result + suffix;
  }

  ({DateTime? exp, DateTime? rem}) _computeDates() {
    if (_settings?.isUseExpiration == true && _settings?.expirationDays != null) {
      final exp = DateTime.now().add(Duration(days: _settings!.expirationDays!));
      DateTime? rem;
      if (_settings?.removalDays != null) rem = exp.subtract(Duration(days: _settings!.removalDays!));
      return (exp: exp, rem: rem);
    }
    return (exp: null, rem: null);
  }

  void _addManualLine() {
    if (!_canAddLine) {
      _snack('Total Quantity sudah sama dengan Demand Quantity.');
      return;
    }
    final d = _computeDates();
    setState(() {
      _lines.add(_TrackingLine(
        lotCtrl: TextEditingController(),
        qtyCtrl: TextEditingController(text: '1'),
        expirationDate: d.exp,
        removalDate: d.rem,
      ));
      _showGenerateForm = false;
    });
  }

  void _removeLine(int index) {
    setState(() {
      _lines[index].dispose();
      _lines.removeAt(index);
    });
  }

  void _openGenerateForm() {
    String firstLot;
    int qtyPerLot = 1;

    if (_lines.isNotEmpty) {
      final last = _lines.last;
      final fmt = _extractLotFormat(last.lotCtrl.text.trim());
      firstLot = _formatLotNumber(fmt.prefix, fmt.numericPart + 1, fmt.digitCount, fmt.suffix);
      qtyPerLot = int.tryParse(last.qtyCtrl.text) ?? 1;
    } else if (_settings?.isAutoGenerateLot == true) {
      firstLot = _formatLotNumber(
        _settings!.lotPrefix ?? '',
        _settings!.lastSequence + 1,
        _settings!.lotDigitNumber,
        _settings!.lotSuffix ?? '',
      );
    } else {
      firstLot = 'LOT-001';
    }

    setState(() {
      _firstLotCtrl.text = firstLot;
      _qtyPerLotCtrl.text = _isSerial ? '1' : qtyPerLot.toString();
      _keepCurrentLines = false;
      _showGenerateForm = true;
    });
  }

  void _generateLines() {
    final firstLotInput = _firstLotCtrl.text.trim();
    final qtyPerLot = int.tryParse(_qtyPerLotCtrl.text) ?? 1;
    final demandQty = widget.item.demandQty;

    if (firstLotInput.isEmpty) {
      _snack('Please enter First Lot Number');
      return;
    }
    if (qtyPerLot <= 0) {
      _snack('Quantity per lot must be greater than 0');
      return;
    }

    final inputFormat = _extractLotFormat(firstLotInput);
    final digitCount = inputFormat.digitCount > 0 ? inputFormat.digitCount : 3;

    int maxExistingSeq = 0;
    for (final l in _lines) {
      final f = _extractLotFormat(l.lotCtrl.text.trim());
      if (f.numericPart > maxExistingSeq) maxExistingSeq = f.numericPart;
    }

    int startNumber;
    if (inputFormat.digitCount > 0) {
      startNumber = inputFormat.numericPart;
    } else if (maxExistingSeq > 0) {
      startNumber = maxExistingSeq + 1;
    } else {
      startNumber = (_settings?.lastSequence ?? 0) + 1;
    }

    final existingLots = <String>{};
    double currentTotalQty = 0;

    if (_keepCurrentLines) {
      for (final l in _lines) {
        existingLots.add(l.lotCtrl.text.trim().toLowerCase());
        currentTotalQty += double.tryParse(l.qtyCtrl.text) ?? 0;
      }
    } else {
      for (final l in _lines) {
        l.dispose();
      }
      _lines.clear();
    }

    final remainingQty = demandQty - currentTotalQty;
    if (remainingQty <= 0) {
      _snack('Total quantity already matches demand quantity');
      return;
    }

    final dates = _computeDates();
    double generatedQty = 0;
    int currentNumber = startNumber;
    int skipped = 0;
    int generatedCount = 0;

    while (generatedQty < remainingQty) {
      final lotNumber = _formatLotNumber(inputFormat.prefix, currentNumber, digitCount, inputFormat.suffix);
      if (existingLots.contains(lotNumber.toLowerCase())) {
        currentNumber++;
        skipped++;
        if (skipped > 10000) break;
        continue;
      }

      final remaining = remainingQty - generatedQty;
      final lineQty = _isSerial ? 1.0 : (qtyPerLot.toDouble() < remaining ? qtyPerLot.toDouble() : remaining);

      _lines.add(_TrackingLine(
        lotCtrl: TextEditingController(text: lotNumber),
        qtyCtrl: TextEditingController(text: lineQty.toStringAsFixed(0)),
        expirationDate: dates.exp,
        removalDate: dates.rem,
      ));

      existingLots.add(lotNumber.toLowerCase());
      generatedQty += lineQty;
      currentNumber++;
      generatedCount++;

      if (_isSerial && generatedQty >= remainingQty) break;
    }

    setState(() => _showGenerateForm = false);
    _snack('Generated $generatedCount tracking line(s)${skipped > 0 ? ' ($skipped skipped)' : ''}');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _handleSave() async {
    if (_lines.isEmpty) {
      _snack('Please add at least one tracking line.');
      return;
    }
    for (final l in _lines) {
      if ((double.tryParse(l.qtyCtrl.text) ?? 0) <= 0) {
        _snack('Each tracking line must have a valid quantity greater than 0.');
        return;
      }
      if (l.lotCtrl.text.trim().isEmpty) {
        _snack('Each tracking line must have a lot/serial number.');
        return;
      }
    }
    final seen = <String>{};
    for (final l in _lines) {
      final lot = l.lotCtrl.text.trim().toLowerCase();
      if (!seen.add(lot)) {
        _snack('Duplicate lot/serial number: "${l.lotCtrl.text.trim()}".');
        return;
      }
    }

    setState(() => _saving = true);

    final trackingData = _lines.map((l) => ReceiptNoteLotSerial(
          idProductLotSerial: int.tryParse(l.idProductLotSerial ?? '') ?? 0,
          lotNumber: l.lotCtrl.text.trim(),
          initialQuantity: double.tryParse(l.qtyCtrl.text) ?? 0,
          remainingQuantity: double.tryParse(l.qtyCtrl.text) ?? 0,
          trackingMethod: widget.item.trackingMethod,
        )).toList();

    final ctrl = context.read<ReceiptNoteController>();
    final success = await ctrl.saveTracking(
      idReceiptNoteItem: widget.item.idReceiptNoteItem,
      receivedQty: _totalQty,
      trackingData: trackingData,
    );

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      _snack(ctrl.formError ?? 'Gagal menyimpan tracking.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Tracking Detail',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow('Product Name', widget.item.productName ?? '-'),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(child: _infoRow('Demand Qty', widget.item.demandQty.toStringAsFixed(0))),
                          Expanded(child: _infoRow('Tracking Method', _isSerial ? 'By Serial Number' : 'By Lots')),
                        ],
                      ),
                      if (_loadingSettings)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_settings?.isUseExpiration == true) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(child: _infoRow('Expiration Days', '${_settings?.expirationDays ?? 0}')),
                            Expanded(child: _infoRow('Removal Days', '${_settings?.removalDays ?? 0}')),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (!_readOnly && _showGenerateForm) _buildGenerateForm(),
                      _buildLinesTable(),
                      if (!_readOnly) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _canAddLine ? _addManualLine : null,
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Add'),
                            ),
                            OutlinedButton(
                              onPressed: _showGenerateForm ? null : _openGenerateForm,
                              child: const Text('Auto Generate'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                  if (!_readOnly) ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                      child: _saving
                          ? const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite),
                            )
                          : const Text('Save'),
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

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 10, color: colorGrey)),
            Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _buildGenerateForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(border: Border.all(color: colorGreyLight), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Auto Generate Lot/Serial Numbers', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 8),
          TextField(controller: _firstLotCtrl, decoration: const InputDecoration(labelText: 'First Lot Number', isDense: true)),
          const SizedBox(height: 8),
          TextField(
            controller: _qtyPerLotCtrl,
            keyboardType: TextInputType.number,
            enabled: !_isSerial,
            decoration: const InputDecoration(labelText: 'Quantity per Lot', isDense: true),
          ),
          Row(
            children: [
              Checkbox(value: _keepCurrentLines, onChanged: (v) => setState(() => _keepCurrentLines = v ?? false)),
              const Text('Keep Current Lines'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => setState(() => _showGenerateForm = false), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: _generateLines,
                style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                child: const Text('Generate'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinesTable() {
    if (_lines.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text('No tracking lines', style: GoogleFonts.poppins(color: colorGrey)),
      );
    }
    return Column(
      children: List.generate(_lines.length, (i) {
        final l = _lines[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(width: 20, child: Text('${i + 1}')),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: l.lotCtrl,
                    enabled: !_readOnly,
                    decoration: const InputDecoration(isDense: true, labelText: 'Lot/Serial'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: l.qtyCtrl,
                    enabled: !_readOnly && !_isSerial,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(isDense: true, labelText: 'Qty'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                if (!_readOnly)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: colorError, size: 20),
                    onPressed: () => _removeLine(i),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}