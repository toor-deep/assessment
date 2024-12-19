import 'package:flutterriverpod/core/usecases/usecase.dart';
import 'package:flutterriverpod/features/product_list/data/data_source/product_data_source.dart';
import 'package:flutterriverpod/features/product_list/domain/entity/product_entity.dart';
import 'package:flutterriverpod/features/product_list/domain/repository/product_repository.dart';

import '../../../../shared/domain/models/either.dart';
import '../../../../shared/exceptions/http_exception.dart';

class AddItemUseCase {
  final ProductRepository productRepository;

  AddItemUseCase({required this.productRepository});

  Future<Either<AppException, void>> call(ItemInputParams params) async {
    return await productRepository.addItem(params);
  }
}
