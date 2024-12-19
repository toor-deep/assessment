import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutterriverpod/shared/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'core/routing.dart';
import 'features/auth/presentation/auth/screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyC5Oeu0QZmem4whVtz6tqUCy9AeQbjNto4',
          appId: "1:588987841094:android:9b5b78162640416ae82847",
          messagingSenderId: '588987841094',
          projectId:  "flutterassesment-f76c1",));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => StyledToast(
        locale: const Locale('en', 'US'),
        textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
        // backgroundColor: const Color(0x99000000),
        borderRadius: BorderRadius.circular(5.0),
        textPadding:
        const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        toastPositions: StyledToastPosition.top,
        toastAnimation: StyledToastAnimation.slideFromTopFade,
        reverseAnimation: StyledToastAnimation.slideToTopFade,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
        duration: const Duration(seconds: 3),
        animDuration: const Duration(milliseconds: 200),
        dismissOtherOnShow: true,
        fullWidth: false,
        isHideKeyboard: true,
        isIgnoring: true,
        child:   ProviderScope(
          child: MaterialApp.router(
            title: kAppName,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            debugShowMaterialGrid: false,
            builder: (context, child) => Stack(
              children: [
                child ?? const SizedBox(),
                const DropdownAlert(
                  position: AlertPosition.TOP,
                )
              ],
            ),
              routerConfig: appRouter,
          ),
        )
      ),
    );
  }

}


