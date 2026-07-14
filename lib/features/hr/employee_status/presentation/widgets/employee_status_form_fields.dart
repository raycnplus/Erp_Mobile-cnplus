import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/models/employee_status_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class EmployeeStatusFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final EmployeeStatusFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const EmployeeStatusFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<EmployeeStatusFormFields> createState() =>
      _EmployeeStatusFormFieldsState();
}

class _EmployeeStatusFormFieldsState
    extends State<EmployeeStatusFormFields> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.formData.employeeStatusName,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _saveForm() {
    widget.formData.employeeStatusName =
        nameController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  CustomFormInput(
                    controller: nameController,
                    label: 'Status Name',
                    required: true,
                    hintText:
                        'Enter status name',
                    validator: (_) {
                      if (nameController.text
                          .trim()
                          .isEmpty) {
                        return 'Status name is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Status',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _StatusOption(
                          label: 'Active',
                          isSelected:
                              widget
                                      .formData
                                      .isActive ==
                                  'Y',
                          color:
                              colorSuccess,
                          icon: Icons
                              .check_circle_outline,
                          onTap: () {
                            setState(() {
                              widget
                                      .formData
                                      .isActive =
                                  'Y';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatusOption(
                          label: 'Inactive',
                          isSelected:
                              widget
                                      .formData
                                      .isActive ==
                                  'N',
                          color: colorGrey,
                          icon: Icons
                              .cancel_outlined,
                          onTap: () {
                            setState(() {
                              widget
                                      .formData
                                      .isActive =
                                  'N';
                            });
                          },
                        ),
                      ),
                    ],
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
                  color: Colors.black
                      .withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(
                    0,
                    -2,
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveForm();
                  widget.onSubmit();
                },
                style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                          colorPrimary,
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                      shape:
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                          ),
                    ),
                child: Text(
                  widget.isEditMode
                      ? 'Update Status'
                      : 'Create Status',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
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

class _StatusOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _StatusOption({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(10),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
              vertical: 12,
            ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? color.withOpacity(0.1)
                  : colorBackground,
          borderRadius:
              BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected
                    ? color
                    : colorGreyLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color:
                  isSelected
                      ? color
                      : colorGrey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight:
                    isSelected
                        ? FontWeight.w700
                        : FontWeight.normal,
                color:
                    isSelected
                        ? color
                        : colorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}