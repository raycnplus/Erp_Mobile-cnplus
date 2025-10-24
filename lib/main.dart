import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'services/connectivity_service.dart';
import 'core/widgets/connectivity_banner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final connectivityService = ConnectivityService();

  runApp(
    StreamProvider<bool>(
      create: (_) => connectivityService.connectionStream,
      initialData: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan textSelectionTheme ada (fallback) agar tidak tergantung override lain
    final baseTheme = AppTheme.lightTheme;
    final ensuredTheme = baseTheme.copyWith(
      textSelectionTheme: baseTheme.textSelectionTheme.copyWith(
        selectionColor: const Color.fromRGBO(58, 121, 183, 0.25),
        selectionHandleColor: const Color.fromARGB(255, 58, 121, 183),
        cursorColor: const Color.fromARGB(255, 58, 121, 183),
      ),
    );

    return MaterialApp(
      title: 'ERP Mobile CNPlus',
      debugShowCheckedModeBanner: false,
      theme: ensuredTheme,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
      builder: (context, child) {
        return ConnectivityBanner(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}