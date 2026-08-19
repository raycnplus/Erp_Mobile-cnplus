import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/controllers/stock_count_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/models/stock_count_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/widgets/stock_count_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'stock_count_detail_screen.dart';

class StockCountFormScreen extends StatefulWidget {
  const StockCountFormScreen({super.key});

  @override
  State<StockCountFormScreen> createState() => _State();
}

class _State extends State<StockCountFormScreen> {
  SCWarehouseOption? _warehouse;
  SCLocationOption? _location;
  String _selectBy = 'all';
  final _noteCtrl = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    await context.read<StockCountController>().fetchFormOptions();
    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<void> _handleSave() async {
    if (_warehouse == null) {
      _snack('Please select warehouse');
      return;
    }
    final ctrl = context.read<StockCountController>();
    final success = await ctrl.create(
      idWarehouse: _warehouse!.id,
      idLocation: _location?.id,
      selectBy: _selectBy,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );
    if (!mounted) return;
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StockCountDetailScreen(encryption: ctrl.savedEncryption!)),
      );
    } else {
      _snack(ctrl.formError ?? 'Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Stock Count', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<StockCountController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              StockCountFormFields(
                formOptions: ctrl.formOptions,
                warehouse: _warehouse,
                location: _location,
                selectBy: _selectBy,
                noteCtrl: _noteCtrl,
                onWarehouseChanged: (v) => setState(() {
                  _warehouse = v;
                  _location = null;
                }),
                onLocationChanged: (v) => setState(() => _location = v),
                onSelectByChanged: (v) => setState(() => _selectBy = v),
                onSave: _handleSave,
                isSaving: ctrl.isSaving,
              ),
              if (ctrl.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator(color: colorPrimary)),
                ),
            ],
          );
        },
      ),
    );
  }
}