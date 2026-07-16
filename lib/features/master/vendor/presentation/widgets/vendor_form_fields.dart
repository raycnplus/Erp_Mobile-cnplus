import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/data/models/vendor_models.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final VendorFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final List<CountryModel> countries;
  final List<CurrencyModel> currencies;
  final bool isLoadingDropdown;

  const VendorFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.countries,
    required this.currencies,
    required this.isLoadingDropdown,
  });

  @override
  State<VendorFormFields> createState() => _VendorFormFieldsState();
}

class _VendorFormFieldsState extends State<VendorFormFields>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController nameCtrl;
  late TextEditingController codeCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController cityCtrl;
  late TextEditingController provinceCtrl;
  late TextEditingController postalCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController npwpCtrl;
  late TextEditingController picNameCtrl;
  late TextEditingController picPhoneCtrl;
  late TextEditingController picEmailCtrl;
  late TextEditingController bankNameCtrl;
  late TextEditingController bankAccountNameCtrl;
  late TextEditingController bankAccountNumberCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    nameCtrl = TextEditingController(text: widget.formData.vendorName);
    codeCtrl = TextEditingController(text: widget.formData.vendorCode);
    addressCtrl = TextEditingController(text: widget.formData.address);
    cityCtrl = TextEditingController(text: widget.formData.city);
    provinceCtrl = TextEditingController(text: widget.formData.province);
    postalCtrl = TextEditingController(text: widget.formData.postalCode);
    phoneCtrl = TextEditingController(text: widget.formData.phoneNo);
    emailCtrl = TextEditingController(text: widget.formData.email);
    npwpCtrl = TextEditingController(text: widget.formData.npwpNumber);
    picNameCtrl = TextEditingController(text: widget.formData.contactPersonName);
    picPhoneCtrl = TextEditingController(text: widget.formData.contactPersonPhone);
    picEmailCtrl = TextEditingController(text: widget.formData.contactPersonEmail);
    bankNameCtrl = TextEditingController(text: widget.formData.bankName);
    bankAccountNameCtrl = TextEditingController(text: widget.formData.bankAccountName);
    bankAccountNumberCtrl = TextEditingController(text: widget.formData.bankAccountNumber);
  }

  @override
  void dispose() {
    _tabController.dispose();
    nameCtrl.dispose(); codeCtrl.dispose(); addressCtrl.dispose();
    cityCtrl.dispose(); provinceCtrl.dispose(); postalCtrl.dispose();
    phoneCtrl.dispose(); emailCtrl.dispose(); npwpCtrl.dispose();
    picNameCtrl.dispose(); picPhoneCtrl.dispose(); picEmailCtrl.dispose();
    bankNameCtrl.dispose(); bankAccountNameCtrl.dispose();
    bankAccountNumberCtrl.dispose();
    super.dispose();
  }

  void _saveAllFields() {
    widget.formData.vendorName = nameCtrl.text;
    widget.formData.vendorCode = codeCtrl.text;
    widget.formData.address = addressCtrl.text;
    widget.formData.city = cityCtrl.text;
    widget.formData.province = provinceCtrl.text;
    widget.formData.postalCode = postalCtrl.text;
    widget.formData.phoneNo = phoneCtrl.text;
    widget.formData.email = emailCtrl.text;
    widget.formData.npwpNumber = npwpCtrl.text;
    widget.formData.contactPersonName = picNameCtrl.text;
    widget.formData.contactPersonPhone = picPhoneCtrl.text;
    widget.formData.contactPersonEmail = picEmailCtrl.text;
    widget.formData.bankName = bankNameCtrl.text;
    widget.formData.bankAccountName = bankAccountNameCtrl.text;
    widget.formData.bankAccountNumber = bankAccountNumberCtrl.text;
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
                Tab(text: "Contact"),
                Tab(text: "Financial"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralTab(),
                _buildContactTab(),
                _buildFinancialTab(),
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
                  widget.isEditMode ? "Update Vendor" : "Create Vendor",
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
            label: "Vendor Name",
            required: true,
            hintText: "Enter vendor name",
            validator: (_) => nameCtrl.text.trim().isEmpty
                ? "Vendor name is required"
                : null,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: codeCtrl,
            label: "Vendor Code",
            required: true,
            hintText: "Enter vendor code",
            validator: (_) => codeCtrl.text.trim().isEmpty
                ? "Vendor code is required"
                : null,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: npwpCtrl,
            label: "NPWP Number",
            hintText: "Enter NPWP number",
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Company Contact",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorBlack)),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: phoneCtrl,
              label: "Phone Number",
              hintText: "Enter phone number",
              keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: emailCtrl,
              label: "Email",
              hintText: "Enter email",
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 24),
          const Text("Contact Person (PIC)",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorBlack)),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: picNameCtrl,
              label: "PIC Name",
              hintText: "Enter PIC name"),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: picPhoneCtrl,
              label: "PIC Phone",
              hintText: "Enter PIC phone",
              keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: picEmailCtrl,
              label: "PIC Email",
              hintText: "Enter PIC email",
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 24),
          const Text("Address",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorBlack)),
          const SizedBox(height: 16),

          _buildDropdown<CountryModel>(
            label: "Country",
            items: widget.countries,
            selectedId: widget.formData.countryId,
            itemLabel: (c) => c.name,
            itemId: (c) => c.id,
            onChanged: (val) =>
                setState(() => widget.formData.countryId = val?.id),
          ),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: provinceCtrl,
              label: "Province",
              hintText: "Enter province"),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: cityCtrl, label: "City", hintText: "Enter city"),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: postalCtrl,
              label: "Postal Code",
              hintText: "Enter postal code",
              keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: addressCtrl,
              label: "Address",
              hintText: "Enter full address",
              maxLines: 3),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDropdown<CurrencyModel>(
            label: "Currency",
            items: widget.currencies,
            selectedId: widget.formData.currencyId,
            itemLabel: (c) => c.name,
            itemId: (c) => c.id,
            onChanged: (val) =>
                setState(() => widget.formData.currencyId = val?.id),
          ),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: bankNameCtrl,
              label: "Bank Name",
              hintText: "Enter bank name"),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: bankAccountNameCtrl,
              label: "Account Name",
              hintText: "Enter account holder name"),
          const SizedBox(height: 16),
          CustomFormInput(
              controller: bankAccountNumberCtrl,
              label: "Account Number",
              hintText: "Enter account number",
              keyboardType: TextInputType.number),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required List<T> items,
    required int? selectedId,
    required String Function(T) itemLabel,
    required int Function(T) itemId,
    required void Function(T?) onChanged,
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
      ),
    );
  }
}