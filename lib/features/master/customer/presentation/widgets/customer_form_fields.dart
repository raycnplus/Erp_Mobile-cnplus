import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/master/customer/data/models/customer_models.dart';

class CustomerFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final CustomerFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final CustomerDropdownData? dropdownData;
  final bool isLoadingDropdown;

  const CustomerFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.dropdownData,
    required this.isLoadingDropdown,
  });

  @override
  State<CustomerFormFields> createState() => _CustomerFormFieldsState();
}

class _CustomerFormFieldsState extends State<CustomerFormFields>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController nameCtrl;
  late TextEditingController codeCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController provinceCtrl;
  late TextEditingController cityCtrl;
  late TextEditingController postalCodeCtrl;
  late TextEditingController websiteCtrl;
  late TextEditingController picNameCtrl;
  late TextEditingController picPhoneCtrl;
  late TextEditingController picEmailCtrl;
  late TextEditingController npwpCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final f = widget.formData;
    nameCtrl = TextEditingController(text: f.customerName);
    codeCtrl = TextEditingController(text: f.customerCode);
    phoneCtrl = TextEditingController(text: f.phoneNo ?? '');
    emailCtrl = TextEditingController(text: f.email ?? '');
    addressCtrl = TextEditingController(text: f.address ?? '');
    provinceCtrl = TextEditingController(text: f.province ?? '');
    cityCtrl = TextEditingController(text: f.city ?? '');
    postalCodeCtrl = TextEditingController(text: f.postalCode ?? '');
    websiteCtrl = TextEditingController(text: f.website ?? '');
    picNameCtrl = TextEditingController(text: f.picName ?? '');
    picPhoneCtrl = TextEditingController(text: f.picPhone ?? '');
    picEmailCtrl = TextEditingController(text: f.picEmail ?? '');
    npwpCtrl = TextEditingController(text: f.npwp ?? '');
  }

  void _saveAllFields() {
    final f = widget.formData;
    f.customerName = nameCtrl.text;
    f.customerCode = codeCtrl.text;
    f.phoneNo = phoneCtrl.text.isEmpty ? null : phoneCtrl.text;
    f.email = emailCtrl.text.isEmpty ? null : emailCtrl.text;
    f.address = addressCtrl.text.isEmpty ? null : addressCtrl.text;
    f.province = provinceCtrl.text.isEmpty ? null : provinceCtrl.text;
    f.city = cityCtrl.text.isEmpty ? null : cityCtrl.text;
    f.postalCode = postalCodeCtrl.text.isEmpty ? null : postalCodeCtrl.text;
    f.website = websiteCtrl.text.isEmpty ? null : websiteCtrl.text;
    f.picName = picNameCtrl.text.isEmpty ? null : picNameCtrl.text;
    f.picPhone = picPhoneCtrl.text.isEmpty ? null : picPhoneCtrl.text;
    f.picEmail = picEmailCtrl.text.isEmpty ? null : picEmailCtrl.text;
    f.npwp = npwpCtrl.text.isEmpty ? null : npwpCtrl.text;
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in [
      nameCtrl, codeCtrl, phoneCtrl, emailCtrl, addressCtrl,
      provinceCtrl, cityCtrl, postalCodeCtrl, websiteCtrl,
      picNameCtrl, picPhoneCtrl, picEmailCtrl, npwpCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildDropdown<T>({
    required String label,
    bool isRequired = false,
    required List<T> items,
    required T? selectedItem,
    required String Function(T) itemLabel,
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
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: colorPrimary)),
            ),
          ),
        ],
      );
    }
    return KeyedSubtree(
      key: ValueKey('${label}_${items.length}'),
      child: CustomSearchableDropdown<T>(
        value: selectedItem,
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
                Tab(text: "Basic Info"),
                Tab(text: "Contact"),
                Tab(text: "PIC"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicInfoTab(),
                _buildContactTab(),
                _buildPICTab(),
              ],
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
                    offset: const Offset(0, -2))
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
                  widget.isEditMode ? "Update Customer" : "Create Customer",
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

  Widget _buildBasicInfoTab() {
    final items = widget.dropdownData;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(
            controller: nameCtrl,
            label: "Customer Name",
            required: true,
            hintText: "Enter customer name",
            validator: (_) => nameCtrl.text.trim().isEmpty
                ? "Customer name is required"
                : null,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: codeCtrl,
            label: "Customer Code",
            required: true,
            hintText: "Enter customer code",
            validator: (_) => codeCtrl.text.trim().isEmpty
                ? "Customer code is required"
                : null,
          ),
          const SizedBox(height: 16),
          _buildDropdown<CustomerTypeOption>(
            label: "Customer Type",
            isRequired: true,
            clearable: false,
            items: CustomerTypeOption.types,
            selectedItem: widget.formData.customerType != null
                ? CustomerTypeOption.types.firstWhere(
                    (t) => t.value == widget.formData.customerType,
                    orElse: () => CustomerTypeOption.types.first)
                : null,
            itemLabel: (t) => t.displayName,
            onChanged: (val) =>
                setState(() => widget.formData.customerType = val?.value),
            validator: (_) => widget.formData.customerType == null
                ? "Customer type is required"
                : null,
          ),
          const SizedBox(height: 16),
          _buildDropdown<CustomerCategoryDropdown>(
            label: "Customer Category",
            isRequired: true,
            clearable: false,
            items: items?.categories ?? [],
            selectedItem: widget.formData.customerCategory != null &&
                    (items?.categories.isNotEmpty ?? false)
                ? items?.categories.firstWhere(
                    (c) => c.id == widget.formData.customerCategory,
                    orElse: () => items!.categories.first)
                : null,
            itemLabel: (c) => c.name,
            onChanged: (val) =>
                setState(() => widget.formData.customerCategory = val?.id),
            validator: (_) => widget.formData.customerCategory == null
                ? "Customer category is required"
                : null,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: npwpCtrl,
            label: "NPWP",
            hintText: "Enter NPWP number",
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildDropdown<PriceListDropdown>(
            label: "Price List",
            items: items?.priceLists ?? [],
            selectedItem: widget.formData.priceList != null &&
                    (items?.priceLists.isNotEmpty ?? false)
                ? items?.priceLists.firstWhere(
                    (p) => p.id == widget.formData.priceList,
                    orElse: () => items!.priceLists.first)
                : null,
            itemLabel: (p) => p.name,
            onChanged: (val) =>
                setState(() => widget.formData.priceList = val?.id),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    final items = widget.dropdownData;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(
            controller: emailCtrl,
            label: "Email",
            required: true,
            hintText: "Enter email address",
            keyboardType: TextInputType.emailAddress,
            validator: (_) {
              final v = emailCtrl.text.trim();
              if (v.isEmpty) return "Email is required";
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: phoneCtrl,
            label: "Phone Number",
            hintText: "Enter phone number",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: websiteCtrl,
            label: "Website",
            hintText: "Enter website URL",
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 24),
          Text("Address",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorBlack)),
          const SizedBox(height: 12),
          _buildDropdown<CountryDropdown>(
            label: "Country",
            items: items?.countries ?? [],
            selectedItem: widget.formData.country != null &&
                    (items?.countries.isNotEmpty ?? false)
                ? items?.countries.firstWhere(
                    (c) => c.name == widget.formData.country,
                    orElse: () => items!.countries.first)
                : null,
            itemLabel: (c) => c.name,
            onChanged: (val) =>
                setState(() => widget.formData.country = val?.name),
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: provinceCtrl,
            label: "Province",
            hintText: "Enter province",
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: cityCtrl,
            label: "City",
            hintText: "Enter city",
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: postalCodeCtrl,
            label: "Postal Code",
            hintText: "Enter 5 digit postal code",
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: addressCtrl,
            label: "Address",
            hintText: "Enter full address",
            maxLines: 3,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPICTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(
            controller: picNameCtrl,
            label: "PIC Name",
            hintText: "Enter PIC name",
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: picPhoneCtrl,
            label: "PIC Phone",
            hintText: "Enter PIC phone number",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: picEmailCtrl,
            label: "PIC Email",
            hintText: "Enter PIC email address",
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}