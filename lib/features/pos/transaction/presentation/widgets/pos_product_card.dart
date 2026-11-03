import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/data/models/pos_transaction_models.dart';

class PosProductCard extends StatefulWidget {
  final PosProduct product;
  final int qtyInCart;
  final VoidCallback onTap;

  const PosProductCard({
    super.key,
    required this.product,
    required this.qtyInCart,
    required this.onTap,
  });

  @override
  State<PosProductCard> createState() => _PosProductCardState();
}

class _PosProductCardState extends State<PosProductCard> {
  static String? _token;
  bool _tokenReady = _token != null;

  @override
  void initState() {
    super.initState();
    if (_token == null) _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await getIt<FlutterSecureStorage>().read(key: 'token');
    if (mounted) setState(() => _tokenReady = true);
  }

  bool _debugged = false;

Future<void> _debugFetch(String url) async {
  if (_debugged) return;
  _debugged = true;

  final client = HttpClient();
  try {
    final req = await client.getUrl(Uri.parse(url));
    req.followRedirects = false; // supaya redirect ke login kelihatan
    req.headers.set('Authorization', 'Bearer $_token');
    final res = await req.close();

    final bytes = await res.fold<List<int>>([], (a, b) => a..addAll(b));
    final head = String.fromCharCodes(bytes.take(200));

    debugPrint('DEBUG status      : ${res.statusCode}');
    debugPrint('DEBUG content-type: ${res.headers.contentType}');
    debugPrint('DEBUG location    : ${res.headers.value('location')}');
    debugPrint('DEBUG length      : ${bytes.length}');
    debugPrint('DEBUG head        : $head');
  } catch (e) {
    debugPrint('DEBUG error: $e');
  } finally {
    client.close(force: true);
  }
}

  Widget _placeholder() => Container(
        color: colorBackground,
        alignment: Alignment.center,
        child: const Icon(Icons.inventory_2_outlined, size: 40, color: colorGrey),
      );

  Widget _image(String url) {
    if (!_tokenReady) return _placeholder();

    return Image.network(
      url,
      fit: BoxFit.cover,
      headers: _token != null ? {'Authorization': 'Bearer $_token'} : null,
      errorBuilder: (_, error, __) {
        debugPrint('Gambar produk gagal ($url): $error');
        _debugFetch(url);
        return _placeholder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final qtyInCart = widget.qtyInCart;
    final outOfStock = product.onHand <= 0;

    return Opacity(
      opacity: outOfStock ? 0.55 : 1,
      child: Card(
        color: colorCard,
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: qtyInCart > 0 ? colorPrimary : colorGreyLight,
            width: qtyInCart > 0 ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                      _image(product.imageUrl!)
                    else
                      _placeholder(),
                    if (qtyInCart > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$qtyInCart',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: colorWhite,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rp ${formatPrice(product.salesPrice)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      outOfStock ? 'Out of stock' : 'Stock: ${product.onHand}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: outOfStock ? colorError : colorTextSubtle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}