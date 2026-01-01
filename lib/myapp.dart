import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mehfilista/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:mehfilista/features/splash_screen.dart';
import 'package:mehfilista/services/local_provider.dart';
import 'package:mehfilista/theme/theme.dart';
import 'package:mehfilista/theme/theme_provider.dart';

class MyMainApp extends StatefulWidget {
  const MyMainApp({super.key});

  @override
  State<MyMainApp> createState() => _MyMainAppState();
}

class _MyMainAppState extends State<MyMainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return ScreenUtilInit(
            designSize: const Size(393, 852),
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Mehfilista',

                // 🌍 Localization
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('fr')],
                locale: localeProvider.locale,

                // 🌗 Theme
                themeMode: themeProvider.isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,
                theme: TAppTheme.lightTheme,
                darkTheme: TAppTheme.darkTheme,

                home: child,
              );
            },
            child: const SplashScreen(),
          );
        },
      ),
    );
  }
}
