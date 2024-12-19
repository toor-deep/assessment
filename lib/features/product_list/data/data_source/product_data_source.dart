import 'package:flutterriverpod/core/errors/failures.dart';
import 'package:flutterriverpod/features/product_list/data/model/product_model.dart';
import 'package:flutterriverpod/shared/exceptions/http_exception.dart';

import '../../../../core/api/api_url.dart';
import '../../../../shared/domain/models/either.dart';

abstract class ProductDataSource {
  Future<Either<AppException, void>> addItem(ItemInputParams params);
  Future<Either<AppException, List<Product>>> getList();
  Future<Either<AppException, void>> deleteItem(String id);
}

class ProductDataSourceImpl extends ProductDataSource {
  @override
  Future<Either<AppException, void>> addItem(ItemInputParams params) async {
    try {
      final request = ApiUrl.items.doc();

      final data = Product(
        quantity: params.quantity,
         category: params.category,
          price: params.price,
          title: params.title, description: params.description, id: request.id,
      );
      await request.set(data.toMap());
      return Right(null);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, List<Product>>> getList()async {
    try {
      final request = await ApiUrl.items.get();
      final list= request.docs
          .map((doc) => Product.fromMap(doc.data()))
          .toList();
      return Right(list);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> deleteItem(String id) async{
    try {
      await ApiUrl.items.doc(id).delete();
      return Right(null);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }
}

class ItemInputParams {
  String title;
  String description;
  String price;
  String category;
  int quantity;

  ItemInputParams({
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.quantity,
  });
}
