import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterriverpod/features/auth/data/repositories/auth_repository.dart';
import 'package:flutterriverpod/features/auth/domain/repository_impl/auth_repository_impl.dart';
import 'package:flutterriverpod/features/auth/domain/usecase/sign_in.usecase.dart';
import 'package:flutterriverpod/features/auth/domain/usecase/sign_out.usecase.dart';
import 'package:flutterriverpod/features/auth/domain/usecase/sign_up.usecase.dart';
import 'package:flutterriverpod/features/product_list/data/data_source/product_data_source.dart';
import 'package:flutterriverpod/features/product_list/data/repository_impl/product_repository_impl.dart';
import 'package:flutterriverpod/features/product_list/domain/repository/product_repository.dart';
import 'package:flutterriverpod/features/product_list/domain/usecase/add_item.usecase.dart';
import 'package:flutterriverpod/features/product_list/domain/usecase/delete_item.usecase.dart';
import 'package:flutterriverpod/features/product_list/domain/usecase/get_list.usecase.dart';
import 'package:flutterriverpod/features/product_list/presentation/provider/product_notifier.dart';
import 'package:flutterriverpod/features/product_list/presentation/provider/product_state.dart';
import 'package:riverpod/riverpod.dart';

import '../../features/auth/data/data_source/auth_data_source.dart';
import '../../features/auth/presentation/auth/providers/state/auth_notifier.dart';
import '../../features/auth/presentation/auth/providers/state/authentication_state.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceFirebase(),
);
final productDataSourceProvider = Provider<ProductDataSource>(
  (ref) => ProductDataSourceImpl(),
);
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceFirebase()),
);
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(remoteDataSource: ProductDataSourceImpl()),
);
final signInProvider = Provider<SignInUseCase>((ref) => SignInUseCase(
    authRepository:
        AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceFirebase())));
final signUpProvider = Provider<SignUpUseCase>(
  (ref) => SignUpUseCase(
      authRepository:
          AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceFirebase())),
);
final signOutProvider = Provider<SignOutUseCase>(
      (ref) => SignOutUseCase(
      authRepository:
      AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceFirebase())),
);
final productUseCaseProvider = Provider<AddItemUseCase>(
  (ref) => AddItemUseCase(
      productRepository:
          ProductRepositoryImpl(remoteDataSource: ProductDataSourceImpl())),
);
final productListUseCaseProvider = Provider<GetListUseCase>(
      (ref) => GetListUseCase(
      productRepository:
      ProductRepositoryImpl(remoteDataSource: ProductDataSourceImpl())),
);
final deleteItemUseCaseProvider = Provider<DeleteItemUseCase>(
      (ref) => DeleteItemUseCase(
      productRepository:
      ProductRepositoryImpl(remoteDataSource: ProductDataSourceImpl())),
);

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthenticationState>(
  (ref) => AuthNotifier(
    signInUseCase: ref.read(
      signInProvider,
    ),
    signUpUseCase: ref.read(
      signUpProvider,
    ),
    signOutUseCase: ref.read(signOutProvider)
  ),
);

final productNotifierProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(addItemUseCase: ref.read(productUseCaseProvider),getListUseCase: ref.read(productListUseCaseProvider),
  deleteItemUseCase: ref.read(deleteItemUseCaseProvider)),
);
