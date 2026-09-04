import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/data/models/direct_purchase_report_models.dart';

class DirectPurchaseReportListItem
    extends StatelessWidget {
  final DirectPurchaseReportModel item;

  const DirectPurchaseReportListItem({
    super.key,
    required this.item,
  });

  String _formatRupiah(
    String rawValue,
  ) {
    final parts =
        rawValue.split('.');

    final wholePart =
        parts[0];

    final decimalPart =
        parts.length > 1
            ? parts[1]
            : '';

    final buffer =
        StringBuffer();

    for (
      int i = 0;
      i < wholePart.length;
      i++
    ) {
      if (i > 0 &&
          (wholePart.length - i) %
                  3 ==
              0) {
        buffer.write('.');
      }

      buffer.write(
        wholePart[i],
      );
    }

    if (decimalPart.isEmpty) {
      return 'Rp $buffer';
    }

    return 'Rp $buffer,$decimalPart';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      color: colorCard,
      elevation: 2,
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        side:
            const BorderSide(
          color:
              colorGreyLight,
          width: 1,
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            // ==================================================
            // REFERENCE + DATE
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: Text(
                    item.reference,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontWeight:
                          FontWeight
                              .w700,
                      fontSize: 15,
                      color:
                          colorTextPrimary,
                    ),
                  ),
                ),
                Text(
                  item.createdDate,
                  style:
                      GoogleFonts.poppins(
                    fontSize: 11,
                    color:
                        colorTextSubtle,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            // ==================================================
            // PR REFERENCE
            // ==================================================

            Row(
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  size: 14,
                  color:
                      colorTextSubtle,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'PR: ${item.prReference}',
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          colorTextSubtle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 4,
            ),

            // ==================================================
            // VENDOR
            // ==================================================

            Row(
              children: [
                const Icon(
                  Icons.store_outlined,
                  size: 14,
                  color:
                      colorTextSubtle,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    item.vendorName,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          colorTextSubtle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 4,
            ),

            // ==================================================
            // WAREHOUSE
            // ==================================================

            Row(
              children: [
                const Icon(
                  Icons.warehouse_outlined,
                  size: 14,
                  color:
                      colorTextSubtle,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    item
                        .destinationWarehouse,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          colorTextSubtle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 4,
            ),

            // ==================================================
            // LOCATION
            // ==================================================

            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color:
                      colorTextSubtle,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    item
                        .destinationLocation,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          colorTextSubtle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            const Divider(
              height: 1,
              color:
                  colorGreyLight,
            ),

            const SizedBox(
              height: 10,
            ),

            // ==================================================
            // TOTAL + STATUS
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'Total Amount',
                        style:
                            GoogleFonts
                                .poppins(
                          fontSize: 11,
                          color:
                              colorTextSubtle,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        _formatRupiah(
                          item.totalAmountRaw,
                        ),
                        style:
                            GoogleFonts
                                .poppins(
                          fontSize: 14,
                          fontWeight:
                              FontWeight
                                  .w700,
                          color:
                              colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration:
                      BoxDecoration(
                    color: colorPrimary
                        .withOpacity(
                      0.08,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      8,
                    ),
                  ),
                  child: Text(
                    item.status,
                    style:
                        GoogleFonts
                            .poppins(
                      fontSize: 11,
                      fontWeight:
                          FontWeight
                              .w600,
                      color:
                          colorPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}