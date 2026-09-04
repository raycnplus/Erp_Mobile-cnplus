import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/data/models/top_purchase_order_report_models.dart';

class TopPurchaseOrderReportListItem
    extends StatelessWidget {
  final TopPurchaseOrderReportModel item;

  const TopPurchaseOrderReportListItem({
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
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // RANK
            // ==================================================

            Container(
              width: 38,
              height: 38,
              alignment:
                  Alignment.center,
              decoration:
                  BoxDecoration(
                color: colorPrimary
                    .withOpacity(
                  0.08,
                ),
                shape:
                    BoxShape.circle,
              ),
              child: Text(
                '#',
                style:
                    GoogleFonts.poppins(
                  fontWeight:
                      FontWeight.w700,
                  color:
                      colorPrimary,
                ),
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
                    item.reference,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontWeight:
                          FontWeight.w700,
                      fontSize: 15,
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
                    height: 8,
                  ),

                  Text(
                    _formatRupiah(
                      item.totalAmountRaw,
                    ),
                    style:
                        GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w700,
                      color:
                          colorPrimary,
                    ),
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