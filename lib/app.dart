import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_strings.dart';
import 'core/routing/app_router.dart';
import 'core/services/navigation_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash/splash_screen.dart';

/// Design canvas — iPhone 11 portrait. Change once here if your design
/// is on a different frame.
const Size kDesignSize = Size(375, 812);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: kDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // The cook app currently ships a single (light) brand palette.
        // Forcing ThemeMode.light prevents dark-mode TextField fills and
        // other Material widgets from leaking into our cream/ink surfaces
        // when the device is in dark mode. Re-enable the user-controlled
        // theme switch once a real dark variant exists.
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          theme: AppTheme.light,
          darkTheme: AppTheme.light, // mirror, not dark
          themeMode: ThemeMode.light,
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: const SplashScreen(),
        );
      },
    );
  }
}
