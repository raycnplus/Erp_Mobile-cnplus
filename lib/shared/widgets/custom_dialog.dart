import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

enum CustomDialogType { success, error, warning, info }

class CustomDialog extends StatelessWidget {
  final CustomDialogType type;
  final String title;
  final String message;
  final String confirmText;
  final String? cancelText;
  
  const CustomDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.confirmText = 'OK',
    this.cancelText,
  });

  static Future<void> showInfo(
    BuildContext context, {
    required String message,
    String? title,
    CustomDialogType type = CustomDialogType.info,
    String buttonText = 'OK',
    bool barrierDismissible = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomDialog(
        type: type,
        title: title ?? _defaultTitle(type),
        message: message,
        confirmText: buttonText,
      ),
    );
  }

  static Future<bool> showConfirm(
    BuildContext context, {
    required String message,
    String title = 'Confirmation',
    CustomDialogType type = CustomDialogType.warning,
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomDialog(
        type: type,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
    return result ?? false;
  }

  static String _defaultTitle(CustomDialogType type) {
    switch (type) {
      case CustomDialogType.success:
        return 'Success';
      case CustomDialogType.error:
        return 'Failed';
      case CustomDialogType.warning:
        return 'Warning';
      case CustomDialogType.info:
        return 'Information';
    }
  }

  Color get _color {
    switch (type) {
      case CustomDialogType.success:
        return const Color(0xFF2E7D32);
      case CustomDialogType.error:
        return colorError;
      case CustomDialogType.warning:
        return const Color(0xFFF57C00);
      case CustomDialogType.info:
        return colorPrimary;
    }
  }

  IconData get _icon {
    switch (type) {
      case CustomDialogType.success:
        return Icons.check_circle_outline;
      case CustomDialogType.error:
        return Icons.error_outline;
      case CustomDialogType.warning:
        return Icons.warning_amber_rounded;
      case CustomDialogType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConfirm = cancelText != null;

    return Dialog(
      backgroundColor: colorCard,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, size: 30, color: _color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: colorTextSubtle,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (isConfirm) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorTextSubtle.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        cancelText!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: colorTextPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _color,
                      foregroundColor: colorWhite,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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