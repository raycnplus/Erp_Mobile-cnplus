import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/controllers/national_holiday_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/models/national_holiday_models.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/widgets/national_holiday_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class NationalHolidayFormScreen extends StatefulWidget {
  final String? encryption;

  const NationalHolidayFormScreen({super.key, this.encryption});

  @override
  State<NationalHolidayFormScreen> createState() => _NationalHolidayFormScreenState();
}

class _NationalHolidayFormScreenState extends State<NationalHolidayFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late NationalHolidayFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = NationalHolidayFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<NationalHolidayController>();
      ctrl.resetDetail();
      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        if (ctrl.detail != null) {
          setState(() {
            _formData = NationalHolidayFormModel.fromDetail(ctrl.detail!);
            _isInitialized = true;
          });
        }
      } else {
        setState(() => _isInitialized = true);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final ctrl = context.read<NationalHolidayController>();
    final success = isEditMode
        ? await ctrl.edit(widget.encryption!, _formData)
        : await ctrl.save(_formData);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? ctrl.successMessage! : ctrl.formError ?? 'Operation failed'),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));

    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Holiday' : 'Create Holiday',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<NationalHolidayController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              NationalHolidayFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
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