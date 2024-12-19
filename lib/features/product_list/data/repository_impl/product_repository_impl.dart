import 'package:flutterriverpod/features/product_list/data/data_source/product_data_source.dart';
import 'package:flutterriverpod/features/product_list/domain/entity/product_entity.dart';

import 'package:flutterriverpod/shared/domain/models/either.dart';

import 'package:flutterriverpod/shared/exceptions/http_exception.dart';

import '../../domain/repository/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<AppException, void>> addItem(ItemInputParams params) {
    return remoteDataSource.addItem(params);
  }

  @override
  Future<Either<AppException, List<ProductEntity>>> getList() {
    return remoteDataSource.getList().then((value) {
      return value.fold(
        (e) {
          return Left(AppException(message: e.message));
        },
        (data) {
          return Right(data.map((item) => item.toEntity()).toList());
        },
      );
    });
  }

  @override
  Future<Either<AppException, void>> deleteItem(String id) {
   return remoteDataSource.deleteItem(id);
  }
}
