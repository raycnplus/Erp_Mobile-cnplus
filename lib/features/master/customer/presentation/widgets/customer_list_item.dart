import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/master/customer/data/models/customer_models.dart';

class CustomerListItem extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onTap;

  const CustomerListItem({super.key, required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person, color: colorPrimary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customer.customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: colorTextPrimary)),
                        const SizedBox(height: 2),
                        Row(children: [
                          const Icon(Icons.qr_code, size: 13, color: colorTextSubtle),
                          const SizedBox(width: 4),
                          Text(customer.customerCode,
                              style: GoogleFonts.roboto(
                                  color: colorTextSubtle,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(customer.customerType,
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: colorGrey),
                ],
              ),
              if (customer.email != null || customer.phoneNo != null ||
                  customer.city != null) ...[
                const Divider(height: 20, thickness: 0.5),
                Row(
                  children: [
                    if (customer.phoneNo?.isNotEmpty == true)
                      _chip(Icons.phone_outlined, customer.phoneNo!),
                    if (customer.phoneNo?.isNotEmpty == true &&
                        customer.city?.isNotEmpty == true)
                      const SizedBox(width: 16),
                    if (customer.city?.isNotEmpty == true)
                      _chip(Icons.location_city_outlined, customer.city!),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 13, color: colorGrey),
      const SizedBox(width: 4),
      Text(text,
          style: GoogleFonts.poppins(
              fontSize: 12, color: colorGreyDark, fontWeight: FontWeight.w500)),
    ]);
  }
}