import '../../../../shared/domain/models/either.dart';
import '../../../../shared/exceptions/http_exception.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/auth_user.dart';


class SignUpUseCase {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});

  Future<Either<AppException, AuthUser>>call(SignUpParams params) async {
    return await authRepository.signUp(
      email: params.email,
      password: params.password,
    );

  }
}

class SignUpParams {
  final String email;
  final String password;

  SignUpParams({
    required this.email,
    required this.password,
  });
}