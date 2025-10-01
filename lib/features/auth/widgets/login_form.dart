import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController databaseController;
  final VoidCallback onLogin;
  final bool isLoading;
  final List<String> databaseOptions;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.databaseController,
    required this.onLogin,
    required this.isLoading,
    required this.databaseOptions,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Inisialisasi AnimationController untuk feedback tombol
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fungsi untuk menjalankan/membalikkan animasi saat tombol ditekan/dilepas
  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      _animationController.reverse();
      widget.onLogin(); // Panggil fungsi login setelah dilepas
    }
  }

  void _onTapCancel() {
    if (!widget.isLoading) {
      _animationController.reverse();
    }
  }


  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xff409c9c); // Warna tema utama

    // --- Definisi Gaya Input Field ---

    // Border yang lebih halus saat normal
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
    );

    // Border saat fokus (garis lebih tebal dan berwarna tema)
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: themeColor, width: 2.0),
    );

    const inputTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );

    // Gaya untuk label saat berada di dalam field (sebagai placeholder)
    final labelStyleInField = TextStyle(
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w500,
      fontSize: 16, // Ukuran teks standar
    );

    // Gaya untuk label saat mengambang di atas (fokus/terisi)
    const floatingLabelFocusStyle = TextStyle(
      color: themeColor,
      fontWeight: FontWeight.w600,
      fontSize: 14, // Ukuran lebih kecil saat mengambang
    );


    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown Database
            DropdownButtonFormField<String>(
              value: widget.databaseController.text.isNotEmpty
                  ? widget.databaseController.text
                  : null,
              items: widget.databaseOptions
                  .map((db) => DropdownMenuItem(
                value: db,
                child: Text(
                  db,
                  style: inputTextStyle,
                ),
              ))
                  .toList(),
              style: inputTextStyle,
              decoration: InputDecoration(
                labelText: 'Database',
                // Perilaku floating label standar
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: const Icon(Icons.storage),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                labelStyle: labelStyleInField,
                floatingLabelStyle: floatingLabelFocusStyle,
                prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused) ? themeColor : Colors.grey.shade600,
                ),
                isDense: true,
                focusColor: themeColor,
              ),
              borderRadius: BorderRadius.circular(12),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    widget.databaseController.text = value;
                  });
                }
              },
              dropdownColor: Colors.white,
            ),
            const SizedBox(height: 18),
            // Username Input Field (Stylish + Floating Label Standard)
            TextField(
              cursorColor: themeColor,
              controller: widget.emailController,
              style: inputTextStyle,
              decoration: InputDecoration(
                labelText: 'Username',
                // Mengatur label agar beranimasi naik saat fokus/terisi
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: const Icon(Icons.person),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                labelStyle: labelStyleInField,
                floatingLabelStyle: floatingLabelFocusStyle,
                prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused) ? themeColor : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Password Input Field (Stylish + Floating Label Standard)
            TextField(
              cursorColor: themeColor,
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              style: inputTextStyle,
              decoration: InputDecoration(
                labelText: 'Password',
                // Mengatur label agar beranimasi naik saat fokus/terisi
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: const Icon(Icons.lock),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                labelStyle: labelStyleInField,
                floatingLabelStyle: floatingLabelFocusStyle,

                prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused) ? themeColor : Colors.grey.shade600,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: themeColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    }
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),
            // === Login Button dengan Animasi Modern ===
            ScaleTransition(
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
                  splashColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.transparent,

                  child: Container(
                    width: double.infinity,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: widget.isLoading ? null : const LinearGradient(
                        colors: [
                          themeColor,
                          Color(0xff2b6e6e),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      color: widget.isLoading ? Colors.grey.shade400 : null,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: widget.isLoading ? null : [
                        BoxShadow(
                          color: themeColor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: widget.isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
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
            // === END: Login Button dengan Animasi Modern ===
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}