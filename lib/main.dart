import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controllers/billing_controller.dart';
import 'views/dashboard_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🚀 FIXED: Forces the Android System UI to stay transparent and stable to prevent UI jumping
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BillingController()),
      ],
      child: const SmartBillingApp(),
    ),
  );
}

class SmartBillingApp extends StatelessWidget {
  const SmartBillingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Billing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter', // Assuming standard clean font
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const DashboardView(),
    );
  }
}