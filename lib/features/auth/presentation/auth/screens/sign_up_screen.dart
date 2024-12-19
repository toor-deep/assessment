import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterriverpod/shared/toast_alert.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/providers/firebase_providers.dart';
import '../../../../../../shared/constants.dart';
import '../providers/state/auth_notifier.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static String path = '/signUp';
  static String name = 'signUp';
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController(); // New controller
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: authState.when(
        initial: () => _buildUi(),
        loading: () => const Center(child: CircularProgressIndicator()),
        unauthenticated: (message) => _buildUi(),
        authenticated: (user) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/list_view');
          });
        }
      ),
    );
  }

  Widget _buildUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Spacing.hmed,
              Text(
                'Create your account to start using RideMate',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Spacing.hmed,
              TextFormField(
                controller: emailController,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  label: const Text('Email'),
                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Spacing.hmed,
              TextFormField(
                controller: passwordController,
                style: Theme.of(context).textTheme.bodySmall,
                onChanged: (value) {
                  ref.read(authNotifierProvider.notifier).passwordChanged(value);
                },
                decoration: InputDecoration(
                  label: const Text('Password'),
                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true, // Hide password input
              ),
              Spacing.hmed,
              TextFormField(
                controller: confirmPasswordController,
                style: Theme.of(context).textTheme.bodySmall,
                obscureText: true, // Hide confirm password input
                decoration: InputDecoration(
                  label: const Text('Confirm Password'),
                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  // Validate if passwords match
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              Spacing.hmed,

              SizedBox(
                width: double.infinity,
                height: 0.06.sh,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_validateInputs()) {
                      ref.read(authNotifierProvider.notifier).signup(
                        email: emailController.text,
                        password: passwordController.text,

                      );
                    }
                  },
                  child: const Text('Sign Up',style: TextStyle(color: Colors.white),),
                ),
              ),
              Spacing.hlg,
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: 'Sign In',
                        style: const TextStyle(color: Colors.teal),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                             context.goNamed('signIn');
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

  bool _validateInputs() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
     showSnackbar('All fields are required', Colors.red);
      return false;
    }
    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      showSnackbar('Passwords do not match', Colors.red);
      return false;
    }
    return true;
  }
}
