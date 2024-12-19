import 'package:flutterriverpod/features/product_list/domain/entity/product_entity.dart';

import '../../../../shared/domain/models/either.dart';
import '../../../../shared/exceptions/http_exception.dart';
import '../repository/product_repository.dart';

class GetListUseCase {
  final ProductRepository productRepository;

  GetListUseCase({required this.productRepository});

  Future<Either<AppException, List<ProductEntity>>> call() async {
    return await productRepository.getList();
  }
}
