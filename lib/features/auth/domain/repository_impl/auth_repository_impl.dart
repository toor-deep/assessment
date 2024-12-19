import '../../../../shared/domain/models/either.dart';
import '../../../../shared/exceptions/http_exception.dart';
import '../../data/data_source/auth_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/auth_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Stream<AuthUser> get authUser {
    return remoteDataSource.user.map((authUserModel) {
      return authUserModel == null ? AuthUser.empty : authUserModel.toEntity();
    });
  }

  @override
  Future<Either<AppException, AuthUser>> signUp({
    required String email,
    required String password,
  }) async {
    final authModel = await remoteDataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );

    return authModel.fold((p0) {
      return Left(AppException());
    },
            (p0) =>
            Right(
              p0.toEntity(),
            ));
  }

  @override
  Future<Either<AppException, AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    final authModel = await remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return authModel.fold((p0) {
      return Left(AppException());
    },
            (p0) => Right(
          p0.toEntity(),
        ));
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<void> changePassword(String newPassword) async {
    await remoteDataSource.changePassword(newPassword);
  }

  @override
  Future<void> deleteAccount() async {
    return remoteDataSource.deleteAccount();
  }
}
