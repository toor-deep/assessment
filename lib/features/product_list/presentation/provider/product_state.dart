import 'package:flutterriverpod/features/product_list/domain/entity/product_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_state.freezed.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = _Initial;
  const factory ProductState.loading() = _Loading;
  const factory ProductState.loaded({List<ProductEntity>? entity}) = _Loaded;
  const factory ProductState.error({required String message}) = _Error;
}
