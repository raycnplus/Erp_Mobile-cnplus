import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/data/models/pos_transaction_models.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_sale_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

class PosCartScreen extends StatelessWidget {
  const PosCartScreen({super.key});

  void _increment(BuildContext context, PosSaleController sale, int id) {
    if (!sale.increment(id)) {
      final m = sale.consumeMessage();
      if (m != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
    }
  }

  Widget _lineCard(BuildContext context, PosSaleController sale, PosCartLine line) {
    final p = line.product;

    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp ${formatPrice(p.salesPrice)}',
                    style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sessionMoney(line.subtotal),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colorPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.remove_circle_outline, color: colorGrey),
                  onPressed: () => sale.decrement(p.idProduct),
                ),
                SizedBox(
                  width: 28,
                  child: Text(
                    '${line.qty}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.add_circle_outline, color: colorPrimary),
                  onPressed: () => _increment(context, sale, p.idProduct),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.delete_outline, color: colorError),
                  onPressed: () => sale.removeFromCart(p.idProduct),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Cart',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
            fontSize: 20,
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<PosSaleController>(
            builder: (context, sale, child) => TextButton(
              onPressed: sale.isCartEmpty
                  ? null
                  : () {
                      sale.clearCart();
                      Navigator.of(context).pop();
                    },
              child: Text('Clear', style: GoogleFonts.poppins(color: colorError)),
            ),
          ),
        ],
      ),
      body: Consumer<PosSaleController>(
        builder: (context, sale, child) {
          if (sale.isCartEmpty) {
            return const SessionEmptyState(
              icon: Icons.shopping_cart_outlined,
              message: 'Your cart is empty',
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    CustomSearchableDropdown<PosCustomer>(
                      value: sale.customer,
                      items: sale.customers,
                      itemLabel: (c) => c.name,
                      onChanged: sale.selectCustomer,
                      label: 'Customer',
                      hintText: 'Walk-in customer',
                      clearable: true,
                    ),
                    const SizedBox(height: 16),
                    for (final line in sale.cartLines) _lineCard(context, sale, line),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: colorCard,
                  boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, -2))],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total (${sale.cartCount} items)',
                              style: GoogleFonts.poppins(fontSize: 13, color: colorTextSubtle),
                            ),
                            Text(
                              sessionMoney(sale.cartTotal),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: colorPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.posTransactionPayment),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                              foregroundColor: colorWhite,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              'Continue to Payment',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}