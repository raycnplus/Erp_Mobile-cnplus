import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/data/models/top_purchasing_product_report_models.dart';

class TopPurchasingProductReportListItem
    extends StatelessWidget {
  final TopPurchasingProductReportModel item;

  const TopPurchasingProductReportListItem({
    super.key,
    required this.item,
  });

  String _formatNumber(
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
      return buffer.toString();
    }

    return '$buffer,$decimalPart';
  }

  String _formatRupiah(
    String rawValue,
  ) {
    return 'Rp ${_formatNumber(rawValue)}';
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
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            // ==================================================
            // RANK ICON
            // ==================================================

            Container(
              width: 40,
              height: 40,
              alignment:
                  Alignment.center,
              decoration:
                  BoxDecoration(
                color:
                    colorPrimary
                        .withOpacity(
                  0.08,
                ),
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color:
                    colorPrimary,
                size: 22,
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            // ==================================================
            // CONTENT
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    item.product,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w700,
                      color:
                          colorTextPrimary,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .store_outlined,
                        size: 14,
                        color:
                            colorTextSubtle,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          item.vendor,
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              GoogleFonts
                                  .poppins(
                            fontSize:
                                12,
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

                  Row(
                    children: [
                      // DEMAND QTY
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Demand Qty',
                              style:
                                  GoogleFonts
                                      .poppins(
                                fontSize:
                                    11,
                                color:
                                    colorTextSubtle,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              _formatNumber(
                                item
                                    .demandQtyRaw,
                              ),
                              style:
                                  GoogleFonts
                                      .poppins(
                                fontSize:
                                    14,
                                fontWeight:
                                    FontWeight
                                        .w600,
                                color:
                                    colorTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // TOTAL AMOUNT
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .end,
                          children: [
                            Text(
                              'Total Amount',
                              style:
                                  GoogleFonts
                                      .poppins(
                                fontSize:
                                    11,
                                color:
                                    colorTextSubtle,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              _formatRupiah(
                                item
                                    .totalAmountRaw,
                              ),
                              style:
                                  GoogleFonts
                                      .poppins(
                                fontSize:
                                    14,
                                fontWeight:
                                    FontWeight
                                        .w700,
                                color:
                                    colorPrimary,
                              ),
                              textAlign:
                                  TextAlign
                                      .right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}