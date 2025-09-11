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
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xff409c9c), width: 2.0),
    );

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
                  .map((db) => DropdownMenuItem(value: db, child: Text(db)))
                  .toList(),
              decoration: InputDecoration(
                hintText: 'Select Database',
                prefixIcon: const Icon(Icons.storage),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
              cursorColor: const Color(0xff409c9c),
              controller: widget.emailController,
              decoration: InputDecoration(
                hintText: 'Username',
                prefixIcon: const Icon(Icons.person),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Password
            TextField(
              cursorColor: const Color(0xff409c9c),
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
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
            // Login Button
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
                        Color(0xff409c9c), // kiri: terang
                        Color(0xff2b6e6e), // kanan: gelap
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
