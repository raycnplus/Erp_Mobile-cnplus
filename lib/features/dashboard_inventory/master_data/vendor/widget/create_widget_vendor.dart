import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/create_models_vendor.dart';

class VendorCreateWidget extends StatefulWidget {
  const VendorCreateWidget({super.key});

  @override
  State<VendorCreateWidget> createState() => _VendorCreateWidgetState();
}

class _VendorCreateWidgetState extends State<VendorCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  // Controllers
  final TextEditingController vendorNameCtrl = TextEditingController();
  final TextEditingController vendorCodeCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController npwpCtrl = TextEditingController();
  final TextEditingController provinceCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController postalCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController picNameCtrl = TextEditingController();
  final TextEditingController picPhoneCtrl = TextEditingController();
  final TextEditingController picEmailCtrl = TextEditingController();
  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController bankAccountNameCtrl = TextEditingController();
  final TextEditingController bankNumberCtrl = TextEditingController();

  // Dropdowns
  int? selectedCountry;
  int? selectedCurrency;

  List<CountryModel> countries = [];
  List<CurrencyModel> currencies = [];

  bool isLoadingCountry = true;
  bool isLoadingCurrency = true;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _fetchCurrencies();
  }

Future<void> _fetchCountries() async {
  final token = await storage.read(key: "token");

  try {
    final response = await http.get(
      Uri.parse("${ApiBase.baseUrl}/master/countries/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["status"] == true && body["data"] != null) {
        final List data = body["data"];

        setState(() {
          countries = data.map((e) => CountryModel.fromJson(e)).toList();
        });
      } else {
        debugPrint("Response error: status false or data null");
      }
    } else {
      debugPrint("HTTP error: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Exception: $e");
  } finally {
    setState(() {
      isLoadingCountry = false;
    });
  }
}



Future<void> _fetchCurrencies() async {
  final token = await storage.read(key: "token");

  try {
    final response = await http.get(
      Uri.parse("${ApiBase.baseUrl}/master/currency/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["status"] == true && body["data"] != null) {
        final List data = body["data"];

        setState(() {
          currencies = data.map((e) => CurrencyModel.fromJson(e)).toList();
        });

        debugPrint("Currencies loaded: ${currencies.length}");
      } else {
        debugPrint("Response error: status false or data null");
      }
    } else {
      debugPrint("Failed to load currencies: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Error fetching currencies: $e");
  } finally {
    // ✅ supaya spinner berhenti apapun hasilnya
    setState(() => isLoadingCurrency = false);
  }
}

  Future<void> _submitVendor() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await storage.read(key: "token");

    if (selectedCountry == null || selectedCurrency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Country & Currency wajib dipilih")),
      );
      return;
    }

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
      // gunakan key yang lebih mungkin diterima backend
      "id_country": selectedCountry,
      "id_currency": selectedCurrency,
    };

    debugPrint("Request Body: ${jsonEncode(requestBody)}");

    final response = await http.post(
      Uri.parse("${ApiBase.baseUrl}/inventory/vendor"),
      headers: {
        "Authorization": token != null && token.isNotEmpty ? "Bearer $token" : "",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    debugPrint("Response Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");

    // parsing yang aman dan toleran terhadap wrapper
    try {
      final body = jsonDecode(response.body);

      // normalisasi payload: prefer body['data'] jika ada
      final payload = (body is Map && body['data'] != null) ? body['data'] : body;

      // cek pesan sukses di berbagai lokasi
      final success = (body is Map && (body['status'] == true || body['success'] == true)) ||
          (response.statusCode == 200 || response.statusCode == 201);

      if (success) {
        // coba ambil vendor name / id dari payload tanpa memaksa fromJson
        String? vendorName;
        int? vendorId;
        if (payload is Map) {
          vendorName = payload['vendor_name']?.toString() ?? payload['vendorName']?.toString();
          vendorId = payload['id_vendor'] is int ? payload['id_vendor'] : (int.tryParse(payload['id_vendor']?.toString() ?? '') ?? null);
        }

        final message = vendorName != null
            ? "Vendor $vendorName berhasil dibuat"
            : (body is Map && body['message'] != null ? body['message'].toString() : 'Vendor berhasil dibuat');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.pop(context, true);
        });
        return;
      }

      // jika bukan sukses, ambil message jika ada
      final errMsg = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : response.body;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal membuat vendor: $errMsg")));
    } catch (e, st) {
      debugPrint("Parse error: $e\n$st");
      // tampilkan raw body untuk debug
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error parsing response. See logs. Status: ${response.statusCode}")),
      );
    }
  }
// ...existing code...


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Vendor Info
            TextFormField(
              controller: vendorNameCtrl,
              decoration: const InputDecoration(labelText: "Vendor Name"),
              validator: (v) => v!.isEmpty ? "required" : null,
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

            // Country Dropdown
            isLoadingCountry
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<int>(
                    value: selectedCountry,
                    items: countries
                        .map((c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => selectedCountry = val),
                    decoration: const InputDecoration(labelText: "Country"),
                    validator: (v) =>
                        v == null ? "required" : null,
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

            // PIC
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

            // Bank Info
            TextFormField(
              controller: bankNameCtrl,
              decoration: const InputDecoration(labelText: "Bank Name"),
            ),

            // Currency Dropdown
            isLoadingCurrency
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<int>(
                    value: selectedCurrency,
                    items: currencies
                        .map((c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => selectedCurrency = val),
                    decoration: const InputDecoration(labelText: "Currency"),
                    validator: (v) =>
                        v == null ? "required" : null,
                  ),

            TextFormField(
              controller: bankAccountNameCtrl,
              decoration:
                  const InputDecoration(labelText: "Bank Account Name"),
            ),
            TextFormField(
              controller: bankNumberCtrl,
              decoration: const InputDecoration(labelText: "Bank Number"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submitVendor,
              child: const Text("Create Vendor"),
            ),
          ],
        ),
      ),
    );
  }
}
