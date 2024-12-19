import '../../../../shared/domain/models/either.dart';
import '../../../../shared/exceptions/http_exception.dart';
import '../../data/data_source/product_data_source.dart';
import '../repository/product_repository.dart';

class DeleteItemUseCase{
  final ProductRepository productRepository;

  DeleteItemUseCase({required this.productRepository});

  Future<Either<AppException, void>> call(String id) async {
    return await productRepository.deleteItem(id);
  }
}