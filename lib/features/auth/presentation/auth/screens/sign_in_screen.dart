import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterriverpod/core/logic/app_navigation.dart';
import 'package:go_router/go_router.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/providers/firebase_providers.dart';
import '../providers/state/auth_notifier.dart';

class SignInScreen extends HookConsumerWidget {
  static String path = '/';
  static String name = 'signIn';

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    // Controllers
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: authState.when(
        initial: () =>
            buildSignInForm(context, ref, emailController, passwordController),
        loading: () => buildSignInForm(
            context, ref, emailController, passwordController,
            isLoading: true),
        unauthenticated: (message) =>
            buildSignInForm(context, ref, emailController, passwordController),
        authenticated: (user) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/list_view');
          });
        },
      ),
    );
  }

  Widget buildSignInForm(
    BuildContext context,
    WidgetRef ref,
    TextEditingController emailController,
    TextEditingController passwordController, {
    bool isLoading = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome Back, We are happy to have you back',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                style: Theme.of(context).textTheme.bodySmall,
                onChanged: (value) {},
                decoration: InputDecoration(
                  label: const Text('Email'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                style: Theme.of(context).textTheme.bodySmall,
                onChanged: (value) {},
                decoration: InputDecoration(
                  label: const Text('Password'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          await ref.read(authNotifierProvider.notifier).login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Sign In',
                          style:
                              TextStyle(color:Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: const TextStyle(color: Colors.teal),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.goNamed('signUp');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
