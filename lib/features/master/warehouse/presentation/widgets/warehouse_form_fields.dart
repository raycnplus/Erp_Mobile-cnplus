import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/models/warehouse_models.dart';
import 'package:google_fonts/google_fonts.dart';

class WarehouseFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final WarehouseFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const WarehouseFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<WarehouseFormFields> createState() => _WarehouseFormFieldsState();
}

class _WarehouseFormFieldsState extends State<WarehouseFormFields>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController nameCtrl;
  late TextEditingController codeCtrl;
  late TextEditingController branchCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController lengthCtrl;
  late TextEditingController widthCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController volumeCtrl;
  late TextEditingController descriptionCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    nameCtrl = TextEditingController(text: widget.formData.warehouseName);
    codeCtrl = TextEditingController(text: widget.formData.warehouseCode);
    branchCtrl = TextEditingController(text: widget.formData.branch);
    addressCtrl = TextEditingController(text: widget.formData.address);
    lengthCtrl = TextEditingController(
        text: widget.formData.length == 0 ? '' : widget.formData.length.toString());
    widthCtrl = TextEditingController(
        text: widget.formData.width == 0 ? '' : widget.formData.width.toString());
    heightCtrl = TextEditingController(
        text: widget.formData.height == 0 ? '' : widget.formData.height.toString());
    volumeCtrl = TextEditingController(
        text: widget.formData.volume == 0 ? '' : widget.formData.volume.toString());
    descriptionCtrl = TextEditingController(text: widget.formData.description);

    lengthCtrl.addListener(_calculateVolume);
    widthCtrl.addListener(_calculateVolume);
    heightCtrl.addListener(_calculateVolume);
  }

  void _calculateVolume() {
    final l = num.tryParse(lengthCtrl.text) ?? 0;
    final w = num.tryParse(widthCtrl.text) ?? 0;
    final h = num.tryParse(heightCtrl.text) ?? 0;
    final v = l * w * h;
    volumeCtrl.text = v > 0 ? v.toString() : '';
  }

  void _saveAllFields() {
    widget.formData.warehouseName = nameCtrl.text;
    widget.formData.warehouseCode = codeCtrl.text;
    widget.formData.branch = branchCtrl.text;
    widget.formData.address = addressCtrl.text;
    widget.formData.length = num.tryParse(lengthCtrl.text) ?? 0;
    widget.formData.width = num.tryParse(widthCtrl.text) ?? 0;
    widget.formData.height = num.tryParse(heightCtrl.text) ?? 0;
    widget.formData.volume = num.tryParse(volumeCtrl.text) ?? 0;
    widget.formData.description = descriptionCtrl.text;
  }

  @override
  void dispose() {
    _tabController.dispose();
    nameCtrl.dispose(); codeCtrl.dispose(); branchCtrl.dispose();
    addressCtrl.dispose(); lengthCtrl.dispose(); widthCtrl.dispose();
    heightCtrl.dispose(); volumeCtrl.dispose(); descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            color: colorCard,
            child: TabBar(
              controller: _tabController,
              labelColor: colorPrimary,
              unselectedLabelColor: colorGrey,
              indicatorColor: colorPrimary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: "General"),
                Tab(text: "Dimensions"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildGeneralTab(), _buildDimensionsTab()],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorCard,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2)),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveAllFields();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? "Update Warehouse" : "Create Warehouse",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(
            controller: nameCtrl,
            label: "Warehouse Name",
            required: true,
            hintText: "Enter warehouse name",
            validator: (_) => nameCtrl.text.trim().isEmpty
                ? "Warehouse name is required"
                : null,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: codeCtrl,
            label: "Warehouse Code",
            required: true,
            hintText: "Enter warehouse code",
            validator: (_) => codeCtrl.text.trim().isEmpty
                ? "Warehouse code is required"
                : null,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: branchCtrl,
            label: "Branch",
            hintText: "Enter branch name",
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: addressCtrl,
            label: "Address",
            hintText: "Enter warehouse address",
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: descriptionCtrl,
            label: "Description",
            hintText: "Enter description",
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          if (widget.isEditMode && widget.formData.createdDate != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorInfoLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorInfoBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: colorInfo, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('View audit trail in detail screen',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: colorInfo)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDimensionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(
            controller: lengthCtrl,
            label: "Length",
            hintText: "Enter length",
            suffixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('m',
                  style: TextStyle(fontSize: 14, color: colorGrey)),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: widthCtrl,
            label: "Width",
            hintText: "Enter width",
            suffixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('m',
                  style: TextStyle(fontSize: 14, color: colorGrey)),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: heightCtrl,
            label: "Height",
            hintText: "Enter height",
            suffixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('m',
                  style: TextStyle(fontSize: 14, color: colorGrey)),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: volumeCtrl,
            label: "Volume",
            hintText: "Auto-calculated from L × W × H",
            suffixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('m³',
                  style: TextStyle(fontSize: 14, color: colorGrey)),
            ),
            keyboardType: TextInputType.number,
            enabled: false,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}