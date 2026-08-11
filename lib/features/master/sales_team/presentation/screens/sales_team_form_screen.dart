import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/presentation/controllers/sales_team_controller.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/data/models/sales_team_models.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/presentation/widgets/sales_team_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class SalesTeamFormScreen extends StatefulWidget {
  final String? encryption;
  const SalesTeamFormScreen({super.key, this.encryption});

  @override
  State<SalesTeamFormScreen> createState() => _SalesTeamFormScreenState();
}

class _SalesTeamFormScreenState extends State<SalesTeamFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late SalesTeamFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = SalesTeamFormModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final controller = context.read<SalesTeamController>();
      controller.resetDetailState();

      await Future.wait([
        controller.fetchFormDropdownData(),
        if (isEditMode) controller.fetchTeamDetail(widget.encryption!),
      ]);

      if (!mounted) return;
      if (isEditMode && controller.teamDetail != null) {
        setState(() {
          _formData = SalesTeamFormModel.fromDetail(controller.teamDetail!);
          _isInitialized = true;
        });
      } else if (!isEditMode) {
        setState(() => _isInitialized = true);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (!_formData.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
            'Team name, leader, and at least 1 member are required'),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }

    final controller = context.read<SalesTeamController>();
    final bool success = isEditMode
        ? await controller.editTeam(widget.encryption!, _formData)
        : await controller.saveTeam(_formData);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success
          ? controller.successMessage!
          : controller.formError ?? 'Operation failed'),
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
          isEditMode ? "Edit Sales Team" : "Create Sales Team",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<SalesTeamController>(
        builder: (context, controller, child) {
          if (!_isInitialized || controller.isLoadingDropdown) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }
          if (isEditMode &&
              controller.teamDetail == null &&
              controller.detailError != null) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.error_outline, size: 64, color: colorError),
                const SizedBox(height: 16),
                Text(controller.detailError!,
                    style: GoogleFonts.poppins(color: colorError)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      controller.fetchTeamDetail(widget.encryption!),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary, foregroundColor: colorWhite),
                  child: const Text("Try Again"),
                ),
              ]),
            );
          }

          return Stack(
            children: [
              SalesTeamFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
                dropdownData: controller.dropdownData,
                isLoadingDropdown: controller.isLoadingDropdown,
              ),
              if (controller.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(
                      child: CircularProgressIndicator(color: colorPrimary)),
                ),
            ],
          );
        },
      ),
    );
  }
}