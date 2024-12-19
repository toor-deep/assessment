import 'package:flutterriverpod/features/product_list/domain/entity/product_entity.dart';

import '../../../../shared/domain/models/either.dart';
import '../../../../shared/exceptions/http_exception.dart';
import '../../data/data_source/product_data_source.dart';

abstract class ProductRepository{
  Future<Either<AppException, void>> addItem(ItemInputParams params);
  Future<Either<AppException, List<ProductEntity>>> getList();
  Future<Either<AppException, void>> deleteItem(String id);
}