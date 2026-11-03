import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

Future<bool> showPosPinDialog(
  BuildContext context, {
  required String storeName,
  required Future<String?> Function(String pin) onVerify,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _PosPinDialog(storeName: storeName, onVerify: onVerify),
  );
  return result == true;
}

class _PosPinDialog extends StatefulWidget {
  final String storeName;
  final Future<String?> Function(String pin) onVerify;

  const _PosPinDialog({required this.storeName, required this.onVerify});

  @override
  State<_PosPinDialog> createState() => _PosPinDialogState();
}

class _PosPinDialogState extends State<_PosPinDialog> {
  final _pinCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _pinCtrl.text;
    if (pin.length != 6) {
      setState(() => _error = 'PIN harus 6 digit angka.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final err = await widget.onVerify(pin);
    if (!mounted) return;

    if (err == null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _loading = false;
        _error = err;
        _pinCtrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'PIN Kasir',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan PIN untuk membuka ${widget.storeName}',
            style: GoogleFonts.poppins(fontSize: 13, color: colorTextSubtle),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pinCtrl,
            autofocus: true,
            obscureText: true,
            enabled: !_loading,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 22, letterSpacing: 8),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: (_) => _submit(),
            onChanged: (v) {
              if (v.length == 6 && !_loading) _submit();
            },
            decoration: InputDecoration(
              counterText: '',
              errorText: _error,
              filled: true,
              fillColor: colorBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: colorPrimary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
          ),
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite),
                )
              : const Text('Masuk'),
        ),
      ],
    );
  }
}