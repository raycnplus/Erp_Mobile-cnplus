import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../../services/api_base.dart';
import '../models/update_models_vendor.dart';

class VendorUpdateWidget extends StatefulWidget {
  final String vendorId;

  const VendorUpdateWidget({super.key, required this.vendorId});

  @override
  State<VendorUpdateWidget> createState() => _VendorUpdateWidgetState();
}

class _VendorUpdateWidgetState extends State<VendorUpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  // Controllers
  late TextEditingController vendorNameCtrl;
  late TextEditingController vendorCodeCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController npwpCtrl;
  late TextEditingController provinceCtrl;
  late TextEditingController cityCtrl;
  late TextEditingController postalCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController picNameCtrl;
  late TextEditingController picPhoneCtrl;
  late TextEditingController picEmailCtrl;
  late TextEditingController bankNameCtrl;
  late TextEditingController bankAccountNameCtrl;
  late TextEditingController bankNumberCtrl;

  // Dropdowns
  int? selectedCountry;
  int? selectedCurrency;

  List<CountryModel> countries = [];
  List<CurrencyModel> currencies = [];

  bool isLoadingCountry = true;
  bool isLoadingCurrency = true;
  bool isLoadingVendor = true;
  int? _vendorCountryFromApi;
  int? _vendorCurrencyFromApi;

  @override
  void initState() {
    super.initState();
    // init kosong dulu
    vendorNameCtrl = TextEditingController();
    vendorCodeCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    npwpCtrl = TextEditingController();
    provinceCtrl = TextEditingController();
    cityCtrl = TextEditingController();
    postalCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    picNameCtrl = TextEditingController();
    picPhoneCtrl = TextEditingController();
    picEmailCtrl = TextEditingController();
    bankNameCtrl = TextEditingController();
    bankAccountNameCtrl = TextEditingController();
    bankNumberCtrl = TextEditingController();

    // load options first (so selected value can match existing items),
    // but fetch vendor detail in parallel — we remember vendor ids and apply after lists loaded.
    _fetchCountries();
    _fetchCurrencies();
    _fetchVendorDetail();
  }

  @override
  void dispose() {
    vendorNameCtrl.dispose();
    vendorCodeCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    npwpCtrl.dispose();
    provinceCtrl.dispose();
    cityCtrl.dispose();
    postalCtrl.dispose();
    addressCtrl.dispose();
    picNameCtrl.dispose();
    picPhoneCtrl.dispose();
    picEmailCtrl.dispose();
    bankNameCtrl.dispose();
    bankAccountNameCtrl.dispose();
    bankNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchVendorDetail() async {
    final token = await storage.read(key: "token");

    try {
      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/purchase/vendor/${widget.vendorId}"),
        headers: {
          "Authorization": token != null && token.isNotEmpty ? "Bearer $token" : "",
          "Accept": "application/json",
        },
      );

      debugPrint("Vendor Detail Response: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // tolerate wrappers: body may be map with data or be the data directly
        final payload = (body is Map && body['data'] != null) ? body['data'] : body;

        // try to extract fields without crashing if names differ
        final vendorMap = payload is Map ? payload : {};
        setState(() {
          vendorNameCtrl.text = (vendorMap['vendor_name'] ?? vendorMap['vendorName'] ?? '').toString();
          vendorCodeCtrl.text = (vendorMap['vendor_code'] ?? vendorMap['vendorCode'] ?? '').toString();
          phoneCtrl.text = (vendorMap['phone_no'] ?? vendorMap['phoneNo'] ?? '').toString();
          emailCtrl.text = (vendorMap['email'] ?? '').toString();
          npwpCtrl.text = (vendorMap['npwp_number'] ?? vendorMap['npwpNumber'] ?? '').toString();
          provinceCtrl.text = (vendorMap['province'] ?? '').toString();
          cityCtrl.text = (vendorMap['city'] ?? '').toString();
          postalCtrl.text = (vendorMap['postal_code'] ?? vendorMap['postalCode'] ?? '').toString();
          addressCtrl.text = (vendorMap['address'] ?? '').toString();
          picNameCtrl.text = (vendorMap['contact_person_name'] ?? vendorMap['contactPersonName'] ?? '').toString();
          picPhoneCtrl.text = (vendorMap['contact_person_phone'] ?? vendorMap['contactPersonPhone'] ?? '').toString();
          picEmailCtrl.text = (vendorMap['contact_person_email'] ?? vendorMap['contactPersonEmail'] ?? '').toString();
          bankNameCtrl.text = (vendorMap['bank_name'] ?? '').toString();
          bankAccountNameCtrl.text = (vendorMap['bank_account_name'] ?? vendorMap['bankAccountName'] ?? '').toString();
          bankNumberCtrl.text = (vendorMap['bank_account_number'] ?? vendorMap['bankAccountNumber'] ?? '').toString();

          // store vendor country/currency and apply after lists loaded
          _vendorCountryFromApi = vendorMap['id_country'] is int
              ? vendorMap['id_country']
              : int.tryParse(vendorMap['id_country']?.toString() ?? '') ?? int.tryParse(vendorMap['country']?.toString() ?? '');
          _vendorCurrencyFromApi = vendorMap['id_currency'] is int
              ? vendorMap['id_currency']
              : int.tryParse(vendorMap['id_currency']?.toString() ?? '') ?? int.tryParse(vendorMap['currency']?.toString() ?? '');
          // if countries/currencies already loaded, apply immediately
          if (countries.isNotEmpty) selectedCountry = _vendorCountryFromApi;
          if (currencies.isNotEmpty) selectedCurrency = _vendorCurrencyFromApi;
        });
      }
    } catch (e) {
      debugPrint("Fetch vendor detail error: $e");
    } finally {
      setState(() => isLoadingVendor = false);
    }
  }

  Future<void> _fetchCountries() async {
    final token = await storage.read(key: "token");

    try {
      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/master/countries/"),
        headers: {
          "Authorization": token != null && token.isNotEmpty ? "Bearer $token" : "",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final list = (body is Map && body['data'] is List) ? body['data'] : (body is List ? body : []);
        setState(() {
          countries = (list as List).map((e) => CountryModel.fromJson(e)).toList();
          // apply vendor country if previously fetched
          if (_vendorCountryFromApi != null) selectedCountry = _vendorCountryFromApi;
        });
      }
    } catch (e) {
      debugPrint("Fetch countries error: $e");
    } finally {
      setState(() => isLoadingCountry = false);
    }
  }

  Future<void> _fetchCurrencies() async {
    final token = await storage.read(key: "token");

    try {
      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/master/currency/"),
        headers: {
          "Authorization": token != null && token.isNotEmpty ? "Bearer $token" : "",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final list = (body is Map && body['data'] is List) ? body['data'] : (body is List ? body : []);
        setState(() {
          currencies = (list as List).map((e) => CurrencyModel.fromJson(e)).toList();
          // apply vendor currency if previously fetched
          if (_vendorCurrencyFromApi != null) selectedCurrency = _vendorCurrencyFromApi;
        });
      }
    } catch (e) {
      debugPrint("Fetch currencies error: $e");
    } finally {
      setState(() => isLoadingCurrency = false);
    }
  }

  Future<void> _updateVendor() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await storage.read(key: "token");

    final requestBody = {
      "vendor_name": vendorNameCtrl.text,
      "vendor_code": vendorCodeCtrl.text,
      "phone_no": phoneCtrl.text,
      "email": emailCtrl.text,
      "npwp_number": npwpCtrl.text,
      "province": provinceCtrl.text,
      "city": cityCtrl.text,
      "postal_code": postalCtrl.text,
      "address": addressCtrl.text,
      "contact_person_name": picNameCtrl.text,
      "contact_person_phone": picPhoneCtrl.text,
      "contact_person_email": picEmailCtrl.text,
      "bank_name": bankNameCtrl.text,
      "bank_account_name": bankAccountNameCtrl.text,
      "bank_account_number": bankNumberCtrl.text,
      "id_country": selectedCountry,
      "id_currency": selectedCurrency,
    };

    debugPrint("Update Body: ${jsonEncode(requestBody)}");

    try {
      final response = await http.put(
        Uri.parse("${ApiBase.baseUrl}/purchase/vendor/${widget.vendorId}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      debugPrint("Update Response Code: ${response.statusCode}");
      debugPrint("Update Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vendor berhasil diupdate")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update vendor: ${response.body}")),
        );
      }
    } catch (e) {
      debugPrint("Update vendor error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingVendor) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: vendorNameCtrl,
              decoration: const InputDecoration(labelText: "Vendor Name"),
              validator: (v) => v == null || v.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: vendorCodeCtrl,
              decoration: const InputDecoration(labelText: "Vendor Code"),
            ),
            TextFormField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: "Phone No"),
            ),
            TextFormField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              controller: npwpCtrl,
              decoration: const InputDecoration(labelText: "NPWP Number"),
            ),

            const SizedBox(height: 10),
            isLoadingCountry
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<int>(
                    value: selectedCountry,
                    items: countries
                        .map((c) => DropdownMenuItem(
                            value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedCountry = val),
                    decoration: const InputDecoration(labelText: "Country"),
                  ),

            TextFormField(
              controller: provinceCtrl,
              decoration: const InputDecoration(labelText: "Province"),
            ),
            TextFormField(
              controller: cityCtrl,
              decoration: const InputDecoration(labelText: "City"),
            ),
            TextFormField(
              controller: postalCtrl,
              decoration: const InputDecoration(labelText: "Postal Code"),
            ),
            TextFormField(
              controller: addressCtrl,
              decoration: const InputDecoration(labelText: "Address"),
              maxLines: 2,
            ),

            const Divider(),
            TextFormField(
              controller: picNameCtrl,
              decoration: const InputDecoration(labelText: "PIC Name"),
            ),
            TextFormField(
              controller: picPhoneCtrl,
              decoration: const InputDecoration(labelText: "PIC Phone"),
            ),
            TextFormField(
              controller: picEmailCtrl,
              decoration: const InputDecoration(labelText: "PIC Email"),
            ),

            const Divider(),
            TextFormField(
              controller: bankNameCtrl,
              decoration: const InputDecoration(labelText: "Bank Name"),
            ),

            isLoadingCurrency
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<int>(
                    value: selectedCurrency,
                    items: currencies
                        .map((c) => DropdownMenuItem(
                            value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedCurrency = val),
                    decoration: const InputDecoration(labelText: "Currency"),
                  ),

            TextFormField(
              controller: bankAccountNameCtrl,
              decoration: const InputDecoration(labelText: "Bank Account Name"),
            ),
            TextFormField(
              controller: bankNumberCtrl,
              decoration: const InputDecoration(labelText: "Bank Number"),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateVendor,
              child: const Text("Update Vendor"),
            ),
          ],
        ),
      ),
    );
  }
}
