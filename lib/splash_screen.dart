import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterriverpod/shared/app_images.dart';
import 'package:flutterriverpod/shared/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  static String path = '/splash';
  static String name = 'splash';

  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      context.goNamed('list_view');
    } else {
      context.goNamed('signIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage(AppImages.book)),
            Spacing.hmed,

          ],
        ),
      ),
    );
  }
}
