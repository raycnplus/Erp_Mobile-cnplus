import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_switch.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/models/product_models.dart';

class ProductFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ProductFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final ProductDropdownData? dropdownData;
  final bool isLoadingDropdown;

  const ProductFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.dropdownData,
    required this.isLoadingDropdown,
  });

  @override
  State<ProductFormFields> createState() => _ProductFormFieldsState();
}

class _ProductFormFieldsState extends State<ProductFormFields>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController nameCtrl;
  late TextEditingController codeCtrl;
  late TextEditingController salesPriceCtrl;
  late TextEditingController purchasePriceCtrl;
  late TextEditingController barcodeCtrl;
  late TextEditingController noteDetailCtrl;
  late TextEditingController weightCtrl;
  late TextEditingController lengthCtrl;
  late TextEditingController widthCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController volumeCtrl;
  late TextEditingController noteInventoryCtrl;
  late TextEditingController expirationDaysCtrl;
  late TextEditingController lotPrefixCtrl;
  late TextEditingController lotSuffixCtrl;
  late TextEditingController lotDigitCtrl;
  late TextEditingController bestBeforeDaysCtrl;
  late TextEditingController removalDaysCtrl;
  late TextEditingController alertDaysCtrl;

  static const _trackingOptions = [
    {'value': 'lots', 'label': 'By Lots'},
    {'value': 'serial_number', 'label': 'By Serial Number'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final f = widget.formData;
    nameCtrl = TextEditingController(text: f.productName);
    codeCtrl = TextEditingController(text: f.productCode);
    salesPriceCtrl = TextEditingController(
        text: (f.salesPrice == null || f.salesPrice == 0)
            ? ''
            : formatPrice(f.salesPrice!));
    purchasePriceCtrl = TextEditingController(
        text: (f.purchasePrice == null || f.purchasePrice == 0)
            ? ''
            : formatPrice(f.purchasePrice!));
    barcodeCtrl = TextEditingController(text: f.barcode);
    noteDetailCtrl = TextEditingController(text: f.noteDetail);
    weightCtrl = TextEditingController(
        text: f.weight == 0 ? '' : f.weight.toString());
    lengthCtrl = TextEditingController(
        text: f.length == 0 ? '' : f.length.toString());
    widthCtrl = TextEditingController(
        text: f.width == 0 ? '' : f.width.toString());
    heightCtrl = TextEditingController(
        text: f.height == 0 ? '' : f.height.toString());
    volumeCtrl = TextEditingController(
        text: f.volume == 0 ? '' : f.volume.toString());
    noteInventoryCtrl = TextEditingController(text: f.noteInventory);
    expirationDaysCtrl = TextEditingController(
        text: f.expirationDays?.toString() ?? '');
    bestBeforeDaysCtrl = TextEditingController(
        text: f.bestBeforeDays?.toString() ?? '');
    removalDaysCtrl = TextEditingController(
        text: f.removalDays?.toString() ?? '');
    alertDaysCtrl = TextEditingController(
        text: f.alertDays?.toString() ?? '');
    lotPrefixCtrl = TextEditingController(text: f.lotPrefix ?? '');
    lotSuffixCtrl = TextEditingController(text: f.lotSuffix ?? '');
    lotDigitCtrl = TextEditingController(
        text: f.lotDigitNumber?.toString() ?? '');

    lengthCtrl.addListener(_calculateVolume);
    widthCtrl.addListener(_calculateVolume);
    heightCtrl.addListener(_calculateVolume);
  }

  void _calculateVolume() {
    final l = double.tryParse(lengthCtrl.text) ?? 0;
    final w = double.tryParse(widthCtrl.text) ?? 0;
    final h = double.tryParse(heightCtrl.text) ?? 0;
    final v = l * w * h;
    volumeCtrl.text = v > 0 ? v.toStringAsFixed(2) : '';
  }

  void _saveAllFields() {
    final f = widget.formData;
    f.productName = nameCtrl.text;
    f.productCode = codeCtrl.text;
    f.salesPrice = parsePrice(salesPriceCtrl.text);
    f.purchasePrice = parsePrice(purchasePriceCtrl.text);
    f.barcode = barcodeCtrl.text;
    f.noteDetail = noteDetailCtrl.text;
    f.weight = double.tryParse(weightCtrl.text) ?? 0;
    f.length = double.tryParse(lengthCtrl.text) ?? 0;
    f.width = double.tryParse(widthCtrl.text) ?? 0;
    f.height = double.tryParse(heightCtrl.text) ?? 0;
    f.volume = double.tryParse(volumeCtrl.text) ?? 0;
    f.noteInventory = noteInventoryCtrl.text;
    f.expirationDays = int.tryParse(expirationDaysCtrl.text);
    f.bestBeforeDays = int.tryParse(bestBeforeDaysCtrl.text);
    f.removalDays = int.tryParse(removalDaysCtrl.text);
    f.alertDays = int.tryParse(alertDaysCtrl.text);
    f.lotPrefix = lotPrefixCtrl.text.isEmpty ? null : lotPrefixCtrl.text;
    f.lotSuffix = lotSuffixCtrl.text.isEmpty ? null : lotSuffixCtrl.text;
    f.lotDigitNumber = int.tryParse(lotDigitCtrl.text);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in [nameCtrl, codeCtrl, salesPriceCtrl, purchasePriceCtrl,
        barcodeCtrl, noteDetailCtrl, weightCtrl, lengthCtrl, widthCtrl,
        heightCtrl, volumeCtrl, noteInventoryCtrl, expirationDaysCtrl,
        lotPrefixCtrl, lotSuffixCtrl, lotDigitCtrl,
        bestBeforeDaysCtrl, removalDaysCtrl, alertDaysCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildDropdown<T>({
    required String label,
    bool isRequired = false,
    required List<T> items,
    required int? selectedId,
    required String Function(T) itemLabel,
    required int Function(T) itemId,
    required void Function(T?) onChanged,
    bool clearable = true,
    String? Function(T?)? validator,
  }) {
    if (widget.isLoadingDropdown && items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorTextPrimary)),
          const SizedBox(height: 8),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: colorGreyLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorGreyLight),
            ),
            child: const Center(
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: colorPrimary),
              ),
            ),
          ),
        ],
      );
    }
    final selected = selectedId != null
        ? items.where((i) => itemId(i) == selectedId).firstOrNull
        : null;
    return KeyedSubtree(
      key: ValueKey('${label}_${items.length}'),
      child: CustomSearchableDropdown<T>(
        value: selected,
        items: items,
        itemLabel: itemLabel,
        onChanged: onChanged,
        label: label,
        isRequired: isRequired,
        clearable: clearable,
        validator: validator,
      ),
    );
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
                Tab(text: "Inventory"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildGeneralTab(), _buildInventoryTab()],
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
                  widget.isEditMode ? "Update Product" : "Create Product",
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
    final items = widget.dropdownData;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(
            controller: nameCtrl,
            label: "Product Name",
            required: true,
            hintText: "Enter product name",
            validator: (_) => nameCtrl.text.trim().isEmpty
                ? "Product name is required"
                : null,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: codeCtrl,
            label: "Product Code",
            required: true,
            hintText: "Enter product code",
            validator: (_) => codeCtrl.text.trim().isEmpty
                ? "Product code is required"
                : null,
          ),
          const SizedBox(height: 24),

          Text("Product Availability",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorBlack)),
          const SizedBox(height: 12),
          CustomSwitchGroup(
            crossAxisCount: 2,
            switches: [
              CustomFormSwitch(
                  label: "Sales",
                  value: widget.formData.sales,
                  onChanged: (v) =>
                      setState(() => widget.formData.sales = v)),
              CustomFormSwitch(
                  label: "Purchase",
                  value: widget.formData.purchase,
                  onChanged: (v) =>
                      setState(() => widget.formData.purchase = v)),
              CustomFormSwitch(
                  label: "Point of Sale",
                  value: widget.formData.pointOfSale,
                  onChanged: (v) =>
                      setState(() => widget.formData.pointOfSale = v)),
              CustomFormSwitch(
                  label: "Direct Purchase",
                  value: widget.formData.directPurchase,
                  onChanged: (v) =>
                      setState(() => widget.formData.directPurchase = v)),
              CustomFormSwitch(
                  label: "Expense",
                  value: widget.formData.expense,
                  onChanged: (v) =>
                      setState(() => widget.formData.expense = v)),
            ],
          ),
          const SizedBox(height: 24),

          _buildDropdown<DropdownProductType>(
            label: "Product Type",
            isRequired: true,
            clearable: false,
            items: items?.productTypes ?? [],
            selectedId: widget.formData.productType,
            itemLabel: (t) => t.name,
            itemId: (t) => t.id,
            onChanged: (v) =>
                setState(() => widget.formData.productType = v?.id),
            validator: (_) => widget.formData.productType == null
                ? "Product type is required"
                : null,
          ),
          const SizedBox(height: 16),

          _buildDropdown<DropdownProductCategory>(
            label: "Product Category",
            isRequired: true,
            clearable: false,
            items: items?.categories ?? [],
            selectedId: widget.formData.productCategory,
            itemLabel: (c) => c.name,
            itemId: (c) => c.id,
            onChanged: (v) =>
                setState(() => widget.formData.productCategory = v?.id),
            validator: (_) => widget.formData.productCategory == null
                ? "Product category is required"
                : null,
          ),
          const SizedBox(height: 16),
          _buildDropdown<DropdownProductBrand>(
            label: "Product Brand",
            isRequired: true,
            clearable: false,
            items: items?.brands ?? [],
            selectedId: widget.formData.productBrand,
            itemLabel: (b) => b.name,
            itemId: (b) => b.id,
            onChanged: (v) =>
                setState(() => widget.formData.productBrand = v?.id),
            validator: (_) => widget.formData.productBrand == null
                ? "Product brand is required"
                : null,
          ),
          const SizedBox(height: 16),

          _buildDropdown<DropdownUnitOfMeasure>(
            label: "Unit of Measure",
            isRequired: true,
            clearable: false,
            items: items?.uoms ?? [],
            selectedId: widget.formData.unitOfMeasure,
            itemLabel: (u) => u.name,
            itemId: (u) => u.id,
            onChanged: (v) =>
                setState(() => widget.formData.unitOfMeasure = v?.id),
            validator: (_) => widget.formData.unitOfMeasure == null
                ? "Unit of measure is required"
                : null,
          ),
          const SizedBox(height: 16),

          CustomFormInput(
            controller: salesPriceCtrl,
            label: "Sales Price",
            hintText: "0",
            keyboardType: TextInputType.number,
            inputFormatters: [PriceInputFormatter()],
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: purchasePriceCtrl,
            label: "Cost Price",
            hintText: "0",
            keyboardType: TextInputType.number,
            inputFormatters: [PriceInputFormatter()],
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: barcodeCtrl,
            label: "Barcode",
            hintText: "Enter barcode",
          ),
          const SizedBox(height: 16),

          CustomFormSwitchHorizontal(
            label: "Enable Tracking",
            subtitle: "Track by lots or serial numbers",
            value: widget.formData.tracking,
            onChanged: (v) => setState(() {
              widget.formData.tracking = v;
              if (!v) {
                widget.formData.trackingMethod = null;
                widget.formData.useExpiration = false;
                widget.formData.autoGenerateLot = false;
              }
            }),
          ),

          if (widget.formData.tracking) ...[
            const SizedBox(height: 16),
            KeyedSubtree(
              key: ValueKey(
                  'tracking_method_${widget.formData.trackingMethod}'),
              child: CustomSearchableDropdown<String>(
                value: widget.formData.trackingMethod,
                items: _trackingOptions.map((m) => m['value']!).toList(),
                itemLabel: (v) => _trackingOptions
                    .firstWhere((m) => m['value'] == v)['label']!,
                onChanged: (v) =>
                    setState(() => widget.formData.trackingMethod = v),
                label: "Tracking Method",
                clearable: false,
                isRequired: true,
              ),
            ),
            const SizedBox(height: 16),
            CustomFormSwitchHorizontal(
              label: "Auto Generate Lot",
              subtitle: "Automatically generate lot numbers",
              value: widget.formData.autoGenerateLot,
              onChanged: (v) =>
                  setState(() => widget.formData.autoGenerateLot = v),
            ),
            if (widget.formData.autoGenerateLot) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomFormInput(
                      controller: lotPrefixCtrl,
                      label: "Lot Prefix",
                      hintText: "e.g. LOT-",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomFormInput(
                      controller: lotSuffixCtrl,
                      label: "Lot Suffix",
                      hintText: "e.g. -A",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomFormInput(
                controller: lotDigitCtrl,
                label: "Digit Number",
                hintText: "e.g. 4",
                keyboardType: TextInputType.number,
              ),
            ],
          ],

          const SizedBox(height: 16),
          CustomFormInput(
            controller: noteDetailCtrl,
            label: "General Notes",
            hintText: "Write note for this product",
            maxLines: 4,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(
            controller: weightCtrl,
            label: "Weight",
            hintText: "Enter weight",
            suffixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('kg',
                    style:
                        TextStyle(fontSize: 14, color: colorGrey))),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: lengthCtrl,
            label: "Length",
            hintText: "Enter length",
            suffixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('cm',
                    style:
                        TextStyle(fontSize: 14, color: colorGrey))),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: widthCtrl,
            label: "Width",
            hintText: "Enter width",
            suffixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('cm',
                    style:
                        TextStyle(fontSize: 14, color: colorGrey))),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: heightCtrl,
            label: "Height",
            hintText: "Enter height",
            suffixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('cm',
                    style:
                        TextStyle(fontSize: 14, color: colorGrey))),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: volumeCtrl,
            label: "Volume",
            hintText: "Auto-calculated from L × W × H",
            suffixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('cm³',
                    style:
                        TextStyle(fontSize: 14, color: colorGrey))),
            keyboardType: TextInputType.number,
            enabled: false,
          ),
          const SizedBox(height: 16),
          CustomFormSwitchHorizontal(
            label: "Use Expiration Date",
            subtitle: "Track expiration dates for lots",
            value: widget.formData.useExpiration,
            onChanged: (v) =>
                setState(() => widget.formData.useExpiration = v),
          ),
          if (widget.formData.useExpiration) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomFormInput(
                    controller: expirationDaysCtrl,
                    label: "Expiration Date",
                    hintText: "Days after receipt",
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFormInput(
                    controller: bestBeforeDaysCtrl,
                    label: "Best Before Date",
                    hintText: "Days before expiration",
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomFormInput(
                    controller: removalDaysCtrl,
                    label: "Removal Date",
                    hintText: "Days before expiration",
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFormInput(
                    controller: alertDaysCtrl,
                    label: "Alert Date",
                    hintText: "Days before expiration",
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          CustomFormInput(
            controller: noteInventoryCtrl,
            label: "Inventory Notes",
            hintText: "Write note for inventory",
            maxLines: 4,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}