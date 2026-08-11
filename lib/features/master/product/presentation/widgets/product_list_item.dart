import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/models/product_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductListItem({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.onHand <= 10;
    final stockColor = isLowStock ? colorStockLow : colorStockSafe;
    final stockLabel = isLowStock ? 'Low Stock!' : 'Safe Stock';

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: colorTextPrimary)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: stockColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: stockColor),
                    ),
                    child: Text(stockLabel,
                        style: TextStyle(
                            color: stockColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                  ),
                ],
              ),
              const Divider(height: 16, thickness: 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Icon(Icons.qr_code, size: 14, color: colorTextSubtle),
                    const SizedBox(width: 4),
                    Text(product.productCode,
                        style: GoogleFonts.roboto(
                            color: colorTextSubtle,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ]),
                  Row(children: [
                    Icon(Icons.inventory, size: 14, color: stockColor),
                    const SizedBox(width: 4),
                    Text('${product.onHand}',
                        style: GoogleFonts.poppins(
                            color: stockColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                  ]),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _PriceChip(
                      label: 'Sales',
                      price: product.salesPrice,
                      color: colorSalesPrice,
                      icon: Icons.sell_outlined),
                  const SizedBox(width: 20),
                  _PriceChip(
                      label: 'Cost',
                      price: product.purchasePrice,
                      color: colorPurchasePrice,
                      icon: Icons.shopping_cart_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final String label;
  final double? price;
  final Color color;
  final IconData icon;
  const _PriceChip(
      {required this.label,
      required this.price,
      required this.color,
      required this.icon});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: colorTextSubtle, fontSize: 11)),
        const SizedBox(height: 2),
        Row(children: [
          Icon(icon, size: 13, color: color.withOpacity(0.8)),
          const SizedBox(width: 4),
          Text(
            price != null ? formatPrice(price!) : '-',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color),
          ),
        ]),
      ],
    );
  }
}