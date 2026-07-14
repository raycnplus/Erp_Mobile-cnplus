import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/models/bank_account_models.dart';

class BankAccountFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final BankAccountFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final BankAccountFormOptions? formOptions;
  final bool isLoadingFormOptions;

  const BankAccountFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.formOptions,
    required this.isLoadingFormOptions,
  });

  @override
  State<BankAccountFormFields> createState() => _BankAccountFormFieldsState();
}

class _BankAccountFormFieldsState extends State<BankAccountFormFields> {
  late TextEditingController bankNameCtrl;
  late TextEditingController accNameCtrl;
  late TextEditingController accNumCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    bankNameCtrl = TextEditingController(text: widget.formData.bankName);
    accNameCtrl = TextEditingController(text: widget.formData.bankAccountName);
    accNumCtrl =
        TextEditingController(text: widget.formData.bankAccountNumber);
    descCtrl =
        TextEditingController(text: widget.formData.description ?? '');
  }

  @override
  void dispose() {
    bankNameCtrl.dispose();
    accNameCtrl.dispose();
    accNumCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.formData.bankName = bankNameCtrl.text;
    widget.formData.bankAccountName = accNameCtrl.text;
    widget.formData.bankAccountNumber = accNumCtrl.text;
    widget.formData.description =
        descCtrl.text.isEmpty ? null : descCtrl.text;
  }

  BankAccountCoaOption? _findCoa(int? id) {
    if (id == null || widget.formOptions == null) return null;
    final matches = widget.formOptions!.coaList.where((c) => c.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingFormOptions) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    final opts = widget.formOptions;
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomFormInput(
                    controller: bankNameCtrl,
                    label: 'Bank Name',
                    required: true,
                    hintText: 'e.g. BCA, Mandiri',
                    validator: (_) => bankNameCtrl.text.trim().isEmpty
                        ? 'Bank name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: accNameCtrl,
                    label: 'Account Name',
                    required: true,
                    hintText: 'Account holder name',
                    validator: (_) => accNameCtrl.text.trim().isEmpty
                        ? 'Account name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: accNumCtrl,
                    label: 'Account Number',
                    required: true,
                    hintText: 'Enter account number',
                    keyboardType: TextInputType.number,
                    validator: (_) => accNumCtrl.text.trim().isEmpty
                        ? 'Account number is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomSearchableDropdown<BankAccountCoaOption>(
                    key: ValueKey(
                      'coa_${widget.formData.idCoa}_${opts?.coaList.length ?? 0}',
                    ),
                    value: _findCoa(widget.formData.idCoa),
                    items: opts?.coaList ?? [],
                    itemLabel: (c) => c.displayName,
                    onChanged: (v) =>
                        setState(() => widget.formData.idCoa = v?.id),
                    label: 'Linked COA (optional)',
                    clearable: true,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: descCtrl,
                    label: 'Description',
                    hintText: 'Optional description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
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
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _save();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode
                      ? 'Update Bank Account'
                      : 'Create Bank Account',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}