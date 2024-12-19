import 'package:flutterriverpod/shared/domain/models/either.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/exceptions/http_exception.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/auth_user.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<Either<AppException, AuthUser>> call(SignInParams params) async {
   return await authRepository.signIn(
        email: params.email,
        password: params.password,
      );

  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}
