import 'package:flutter/material.dart';
import 'package:flutterriverpod/features/auth/domain/entities/auth_user.dart';
import 'package:flutterriverpod/features/auth/domain/usecase/sign_in.usecase.dart';
import 'package:flutterriverpod/features/auth/domain/usecase/sign_out.usecase.dart';
import 'package:flutterriverpod/features/auth/domain/usecase/sign_up.usecase.dart';
import 'package:flutterriverpod/shared/toast_alert.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../../../../../core/providers/firebase_providers.dart';
import 'authentication_state.dart';

class AuthNotifier extends StateNotifier<AuthenticationState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  AuthNotifier({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase
  }) : super(const AuthenticationState.initial());

  AuthUser authUser=AuthUser(id: '');

  Future<void> login({required String email, required String password}) async {
    if (!emailChanged(email) || !passwordChanged(password)) {
      return showSnackbar('Enter valid input', Colors.red);
    }
    state = const AuthenticationState.loading();
    final response = await signInUseCase
        .call(SignInParams(email: email, password: password));

    state = response
        .fold((error) => AuthenticationState.unauthenticated(message: ''),
            (response) {
      setLoggedValue(true);
      authUser=response;
      return AuthenticationState.authenticated(user: response);
    });
  }

  Future<void> signup({required String email, required String password}) async {
    if (!emailChanged(email) || !passwordChanged(password)) {
      return showSnackbar('Enter valid input', Colors.red);
    }
    state = const AuthenticationState.loading();
    final response = await signUpUseCase
        .call(SignUpParams(email: email, password: password));
    state = response
        .fold((error) => AuthenticationState.unauthenticated(message: 'error'),
            (response) {
      setLoggedValue(true);
      return AuthenticationState.authenticated(user: response);
    });
  }

  Future<void> signOut(Function onSuccess) async {
    try {
      await signOutUseCase.call();
     setLoggedValue(false);
      showSnackbar('Log Out Successfully', Colors.green);
      onSuccess();
    } catch (e) {
      showSnackbar(e.toString(), Colors.red);
    }
  }

  bool emailChanged(String value) {
    final email = value.toString();

    final emailRegex = RegExp(r'^[a-z0-9._]+@[a-z0-9]+\.[a-z]+');

    if (emailRegex.hasMatch(email)) {
      return true;
    }
    return false;
  }

  bool passwordChanged(String value) {
    final password = value.toString();

    if (password.length >= 6) {
      return true;
    }
    return false;
  }

  Future<void> setLoggedValue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }
}
