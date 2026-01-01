import 'package:flutter/material.dart';
import 'package:mehfilista/features/auth/provider/auth_provider.dart';
import 'package:mehfilista/features/home/providers/home_provider.dart';
import 'package:mehfilista/features/inquiry/providers/inquiry_provider.dart';
import 'package:mehfilista/features/review/providers/review_provider.dart';
import 'package:mehfilista/features/vendor/providers/vendor_provider.dart';
import 'package:mehfilista/services/local_provider.dart';
import 'package:provider/provider.dart';
import 'package:mehfilista/myapp.dart';
import 'package:mehfilista/theme/theme_provider.dart';
import 'package:mehfilista/utils/helpers/connectivity_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        // Core providers
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),

        // Auth & User
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadUser()),

        // Feature providers
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => InquiryProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: MyMainApp(),
    ),
  );
}
