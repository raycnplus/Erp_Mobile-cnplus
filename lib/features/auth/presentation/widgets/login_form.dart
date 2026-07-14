import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../shared/widgets/fade_in_up.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController databaseController;
  final VoidCallback onLogin;
  final bool isLoading;
  final List<Map<String, String>> databaseOptions;
  final Duration animationDelay;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.databaseController,
    required this.onLogin,
    required this.isLoading,
    required this.databaseOptions,
    required this.animationDelay,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  bool _obscurePassword = true;

  late AnimationController _buttonAnimationController;
  late Animation<double> _scaleAnimation;

  final FocusNode _databaseFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String _getDatabaseLabel(String value) {
    final db = widget.databaseOptions.firstWhere(
      (e) => e['value'] == value,
      orElse: () => {'label': ''},
    );
    return db['label'] ?? '';
  }

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
          parent: _buttonAnimationController, curve: Curves.easeOut),
    );

    _databaseFocusNode.addListener(() => setState(() {}));
    _usernameFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _databaseFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading) _buttonAnimationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      _buttonAnimationController.reverse();
      widget.onLogin();
    }
  }

  void _onTapCancel() {
    if (!widget.isLoading) _buttonAnimationController.reverse();
  }

  void _showDatabaseSelectionSheet(BuildContext context) {
  const Color themeColor = Color(0xff409c9c);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Select Database',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xD9000000),
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.45,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: widget.databaseOptions.map((db) {
                        final isSelected =
                            widget.databaseController.text == db['value'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Material(
                            color: isSelected
                                ? themeColor.withAlpha(26)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () {
                                setModalState(() {
                                  widget.databaseController.text = db['value']!;
                                });
                                Future.delayed(
                                  const Duration(milliseconds: 200),
                                  () {
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.storage_rounded,
                                      color: isSelected
                                          ? themeColor
                                          : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        db['label']!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? themeColor
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: themeColor,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  ).then((_) => setState(() {}));
}

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xff409c9c);
    const inputTextStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87);
    final labelStyle = TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
        fontSize: 16);
    const floatingLabelFocusStyle = TextStyle(
        color: themeColor, fontWeight: FontWeight.w600, fontSize: 14);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInUp(
              delay: widget.animationDelay,
              child: TextFormField(
                focusNode: _databaseFocusNode,
                readOnly: true,
                controller: TextEditingController(
                  text: _getDatabaseLabel(widget.databaseController.text),
                ),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Database',
                  labelStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  floatingLabelStyle: const TextStyle(
                      color: Color(0xff409c9c),
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  prefixIcon: const Icon(Icons.storage),
                  suffixIcon:
                      const Icon(Icons.expand_more, color: Colors.grey),
                  enabledBorder: const _ExpandingUnderlineInputBorder(),
                  focusedBorder: const _ExpandingUnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff409c9c), width: 2.5),
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) =>
                      states.contains(WidgetState.focused)
                          ? const Color(0xff409c9c)
                          : Colors.grey.shade600),
                ),
                onTap: () => _showDatabaseSelectionSheet(context),
              ),
            ),

            const SizedBox(height: 18),

            FadeInUp(
              delay: widget.animationDelay + const Duration(milliseconds: 100),
              child: TextFormField(
                focusNode: _usernameFocusNode,
                cursorColor: themeColor,
                controller: widget.emailController,
                style: inputTextStyle,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: labelStyle,
                  floatingLabelStyle: floatingLabelFocusStyle,
                  prefixIcon: const Icon(Icons.person),
                  enabledBorder: const _ExpandingUnderlineInputBorder(),
                  focusedBorder: const _ExpandingUnderlineInputBorder(
                    borderSide: BorderSide(color: themeColor, width: 2.5),
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) =>
                      states.contains(WidgetState.focused)
                          ? themeColor
                          : Colors.grey.shade600),
                ),
              ),
            ),

            const SizedBox(height: 18),

            FadeInUp(
              delay: widget.animationDelay + const Duration(milliseconds: 200),
              child: TextFormField(
                focusNode: _passwordFocusNode,
                cursorColor: themeColor,
                controller: widget.passwordController,
                obscureText: _obscurePassword,
                style: inputTextStyle,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: labelStyle,
                  floatingLabelStyle: floatingLabelFocusStyle,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: themeColor,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  enabledBorder: const _ExpandingUnderlineInputBorder(),
                  focusedBorder: const _ExpandingUnderlineInputBorder(
                    borderSide: BorderSide(color: themeColor, width: 2.5),
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) =>
                      states.contains(WidgetState.focused)
                          ? themeColor
                          : Colors.grey.shade600),
                ),
              ),
            ),

            const SizedBox(height: 32),

            FadeInUp(
              delay: widget.animationDelay + const Duration(milliseconds: 300),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                  child: InkWell(
                    onTap: widget.isLoading ? null : () {},
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    onTapCancel: _onTapCancel,
                    borderRadius: BorderRadius.circular(26),
                    splashColor: Colors.white.withAlpha(77),
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: widget.isLoading
                            ? null
                            : const LinearGradient(
                                colors: [themeColor, Color(0xff2b6e6e)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                        color:
                            widget.isLoading ? Colors.grey.shade400 : null,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: widget.isLoading
                            ? null
                            : [
                                BoxShadow(
                                  color: themeColor.withAlpha(102),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                      ),
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 3),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ExpandingUnderlineInputBorder extends UnderlineInputBorder {
  const _ExpandingUnderlineInputBorder({
    super.borderSide =
        const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
  });

  @override
  _ExpandingUnderlineInputBorder copyWith(
      {BorderSide? borderSide, BorderRadius? borderRadius}) {
    return _ExpandingUnderlineInputBorder(
      borderSide: borderSide ?? this.borderSide,
    );
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    final Paint greyPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1.5;
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, greyPaint);

    final double expansionFactor = borderSide.width / 2.5;
    if (expansionFactor <= 0) return;

    final double animatedWidth = rect.width * expansionFactor;
    final Offset center = rect.bottomCenter;
    final Offset start =
        Offset(center.dx - animatedWidth / 2, center.dy);
    final Offset end = Offset(center.dx + animatedWidth / 2, center.dy);

    final Paint coloredPaint = borderSide.toPaint();
    canvas.drawLine(start, end, coloredPaint);
  }
}