import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'services/connectivity_service.dart'; 
import 'core/widgets/connectivity_banner.dart'; 

void main() {
  // Pastikan semua service siap sebelum aplikasi berjalan
  WidgetsFlutterBinding.ensureInitialized();
  
  // Buat satu instance dari service-mu yang akan dipakai selamanya
  final connectivityService = ConnectivityService();

  runApp(
    // StreamProvider akan mendengarkan stream dari service
    // dan menyediakan nilai boolean (true/false) ke seluruh widget tree
    StreamProvider<bool>(
      create: (_) => connectivityService.connectionStream,
      initialData: true, 
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP Mobile CNPlus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
      // 'builder' akan membungkus semua halaman dengan banner konektivitas
      builder: (context, child) {
        return ConnectivityBanner(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}