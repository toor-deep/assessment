
import '../../../../shared/domain/models/either.dart';
import '../../../../shared/exceptions/http_exception.dart';
import '../../domain/entities/auth_user.dart';

abstract class AuthRepository {

  Stream<AuthUser> get authUser;

  Future<Either<AppException, AuthUser>> signUp({
    required String email,
    required String password,
  });

  Future<Either<AppException, AuthUser>> signIn({
    required String email,
    required String password,
  });
  Future<void> changePassword(String newPassword);

  Future<void> signOut();
  Future<void> deleteAccount();
}

