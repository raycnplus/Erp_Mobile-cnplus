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

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xff409c9c); // Warna tema utama

    // --- Definisi Style Input Baru (Lebih Minimalis) ---
    // Border tipis dan sangat terang saat tidak fokus
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0), // Lebih tipis (1.0) dan lebih terang (shade200)
    );

    // Border sedikit lebih tebal dan menggunakan warna tema saat fokus
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: themeColor, width: 1.5), // Sedikit lebih tipis dari sebelumnya (2.0 -> 1.5)
    );

    // Style untuk teks yang dimasukkan
    const inputTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600, // Lebih tebal agar menonjol
      color: Colors.black87,
    );

    // Style untuk label yang mengambang (lebih subtle/ringan)
    final floatingLabelStyle = TextStyle(
      color: Colors.grey.shade500, // Sedikit lebih terang
      fontWeight: FontWeight.w400, // Lebih ringan
      fontSize: 14,
    );
    // ---------------------------------------------------

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
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
                  style: inputTextStyle, // Menggunakan style teks input yang baru
                ),
              ))
                  .toList(),
              style: inputTextStyle, // Menggunakan style teks input yang baru
              decoration: InputDecoration(
                hintText: 'Select Database',
                labelText: 'Database',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: const Icon(Icons.storage),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                labelStyle: floatingLabelStyle,
                // Mengubah warna prefix icon saat fokus
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
            // Username
            TextField(
              cursorColor: themeColor,
              controller: widget.emailController,
              style: inputTextStyle, // Menggunakan style teks input yang baru
              decoration: InputDecoration(
                hintText: 'Username',
                labelText: 'Username',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: const Icon(Icons.person),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                // Mengubah warna prefix icon saat fokus
                prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused) ? themeColor : Colors.grey.shade600,
                ),
                labelStyle: floatingLabelStyle,
              ),
            ),
            const SizedBox(height: 18),
            // Password
            TextField(
              cursorColor: themeColor,
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              style: inputTextStyle, // Menggunakan style teks input yang baru
              decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: const Icon(Icons.lock),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                // Mengubah warna prefix icon saat fokus
                prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused) ? themeColor : Colors.grey.shade600,
                ),
                labelStyle: floatingLabelStyle,
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
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Login Button (Tidak ada perubahan)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : widget.onLogin,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        themeColor,
                        Color(0xff2b6e6e),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 52,
                    child: widget.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}