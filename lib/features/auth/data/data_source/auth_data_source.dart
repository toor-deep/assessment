import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../shared/domain/models/either.dart';
import '../../../../shared/exceptions/http_exception.dart';
import '../../domain/entities/auth_user.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUserModel?> get user;

  Future<Either<AppException, AuthUserModel>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<AppException, AuthUserModel>>  signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> changePassword(String newPassword);
  Future<void> deleteAccount();

  Future<void> signOut();
}

class AuthRemoteDataSourceFirebase implements AuthRemoteDataSource {
  AuthRemoteDataSourceFirebase({
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Stream<AuthUserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }
      return AuthUserModel.fromFirebaseAuthUser(firebaseUser);
    });
  }

  @override
  Future<Either<AppException, AuthUserModel>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {

      firebase_auth.UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return Left(AppException(message: 'Sign up failed: The user is null after sign up.'));
      }


      return Right(AuthUserModel.fromFirebaseAuthUser(credential.user!));
    } catch (error) {
      return Left(AppException(message: 'Sign up failed: $error'));
    }
  }

  @override
  Future<Either<AppException, AuthUserModel>>  signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return Left(AppException(message: 'Sign up failed: The user is null after sign up.'));
      }


      return Right(AuthUserModel.fromFirebaseAuthUser(credential.user!));
    } catch (error) {
      return Left(AppException(message: 'Sign up failed: $error'));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  @override
  Future<void> changePassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'No user currently signed in.');
    }
  }


  @override
  Future<void> deleteAccount() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      await user.delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
