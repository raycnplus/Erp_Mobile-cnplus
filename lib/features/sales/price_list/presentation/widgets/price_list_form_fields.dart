import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/models/price_list_models.dart';

class PriceListFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final PriceListFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final List<PriceListProductOption> products;
  final bool isLoadingProducts;

  const PriceListFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.products,
    required this.isLoadingProducts,
  });

  @override
  State<PriceListFormFields> createState() => _PriceListFormFieldsState();
}

class _PriceListFormFieldsState extends State<PriceListFormFields> {
  late TextEditingController nameCtrl, descCtrl;
  final _productSearch = TextEditingController();
  String _productQuery = '';

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.formData.priceListName);
    descCtrl = TextEditingController(text: widget.formData.description ?? '');
    _productSearch.addListener(() => setState(() => _productQuery = _productSearch.text.toLowerCase()));
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    _productSearch.dispose();
    super.dispose();
  }

  void _save() {
    widget.formData.priceListName = nameCtrl.text;
    widget.formData.description = descCtrl.text.isEmpty ? null : descCtrl.text;
  }

  bool _isProductSelected(int idProduct) => widget.formData.items.any((i) => i.idProduct == idProduct);

  void _toggleProduct(PriceListProductOption opt) {
    setState(() {
      if (_isProductSelected(opt.id)) {
        widget.formData.items.removeWhere((i) => i.idProduct == opt.id);
      } else {
        widget.formData.items.add(PriceListFormItem(
          idProduct: opt.id,
          productName: opt.productName,
          productCode: opt.productCode,
          originalPrice: opt.salesPrice,
          customPrice: opt.salesPrice,
        ));
      }
    });
  }

  String _currency(double v) => 'Rp ${v.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+\b)'),
    (m) => '${m[1]}.',
  )}';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = widget.products.where((p) =>
      _productQuery.isEmpty ||
      p.productName.toLowerCase().contains(_productQuery) ||
      p.productCode.toLowerCase().contains(_productQuery),
    ).toList();

    return Form(
      key: widget.formKey,
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              CustomFormInput(
                controller: nameCtrl,
                label: "Price List Name",
                required: true,
                hintText: "Enter price list name",
                validator: (_) => nameCtrl.text.trim().isEmpty ? "Price list name is required" : null,
              ),
              const SizedBox(height: 16),
              Row(children: [
                Text("Status", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorTextPrimary)),
                const SizedBox(width: 16),
                Switch(
                  value: widget.formData.isActive == 'Y',
                  activeColor: colorPrimary,
                  onChanged: (v) => setState(() => widget.formData.isActive = v ? 'Y' : 'N'),
                ),
                Text(
                  widget.formData.isActive == 'Y' ? 'Active' : 'Inactive',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: widget.formData.isActive == 'Y' ? colorSuccess : colorGrey,
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              CustomFormInput(controller: descCtrl, label: "Description", hintText: "Optional description", maxLines: 2),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Products", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: colorTextPrimary)),
                Text(
                  '${widget.formData.items.length} selected',
                  style: GoogleFonts.poppins(fontSize: 12, color: colorPrimary, fontWeight: FontWeight.w600),
                ),
              ]),
              if (widget.formData.items.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('At least 1 product required', style: GoogleFonts.poppins(fontSize: 12, color: colorError)),
                ),
              const SizedBox(height: 8),
              TextField(
                controller: _productSearch,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                  prefixIcon: const Icon(Icons.search, size: 18, color: colorGrey),
                  filled: true,
                  fillColor: colorBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: colorGreyLight),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (widget.isLoadingProducts)
                const Center(child: CircularProgressIndicator(color: colorPrimary))
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 280),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colorGreyLight),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredProducts.length,
                    itemBuilder: (_, i) {
                      final opt = filteredProducts[i];
                      final isSelected = _isProductSelected(opt.id);
                      return ListTile(
                        dense: true,
                        leading: Checkbox(
                          value: isSelected,
                          activeColor: colorPrimary,
                          onChanged: (_) => _toggleProduct(opt),
                        ),
                        title: Text('${opt.productCode} — ${opt.productName}', style: GoogleFonts.poppins(fontSize: 13)),
                        subtitle: Text(_currency(opt.salesPrice), style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                        onTap: () => _toggleProduct(opt),
                      );
                    },
                  ),
                ),
              if (widget.formData.items.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text("Custom Prices", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: colorTextPrimary)),
                const SizedBox(height: 8),
                ...widget.formData.items.map((item) {
                  final ctrl = TextEditingController(text: item.customPrice.toStringAsFixed(0));
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: colorCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: colorGreyLight),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(item.productName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text(item.productCode, style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                          ]),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: ctrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              prefixText: 'Rp ',
                              prefixStyle: GoogleFonts.poppins(fontSize: 13, color: colorTextSubtle),
                              filled: true,
                              fillColor: colorBackground,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: colorGreyLight),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: colorGreyLight),
                              ),
                            ),
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                            onChanged: (v) => item.customPrice = double.tryParse(v) ?? 0,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: colorGrey, size: 18),
                          onPressed: () => setState(() => widget.formData.items.removeWhere((i) => i.idProduct == item.idProduct)),
                        ),
                      ]),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 24),
            ]),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorCard,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(
                widget.isEditMode ? "Update Price List" : "Create Price List",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}