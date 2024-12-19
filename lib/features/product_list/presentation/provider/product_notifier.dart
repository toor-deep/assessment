import 'package:flutter/material.dart';
import 'package:flutterriverpod/features/product_list/data/data_source/product_data_source.dart';
import 'package:flutterriverpod/features/product_list/domain/entity/product_entity.dart';
import 'package:flutterriverpod/features/product_list/domain/usecase/delete_item.usecase.dart';
import 'package:flutterriverpod/features/product_list/domain/usecase/get_list.usecase.dart';
import 'package:flutterriverpod/features/product_list/presentation/provider/product_state.dart';
import 'package:flutterriverpod/shared/toast_alert.dart';
import 'package:state_notifier/state_notifier.dart';
import '../../domain/usecase/add_item.usecase.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final AddItemUseCase addItemUseCase;
  final GetListUseCase getListUseCase;
  final DeleteItemUseCase deleteItemUseCase;
  ProductNotifier({required this.addItemUseCase, required this.getListUseCase,required this.deleteItemUseCase})
      : super(const ProductState.initial()){
    getList();
  }

  List<ProductEntity> productList=[];
  Future<void> addProduct(ItemInputParams params) async {
    try {
      state = const ProductState.loading();
      await addItemUseCase
          .call(params);

      state = ProductState.loaded();
      showSnackbar('Entity Created', Colors.green);
    } catch (e) {
      state = ProductState.error(message: 'Failed to add product');
    }
  }

  Future<void> getList() async {
    try {
      productList=[];
      state = const ProductState.loading();
      final response = await getListUseCase.call();
      response.fold(
        (e) {
          state = ProductState.error(message: e.message ?? "");
        },
        (data) {
          state = ProductState.loaded(entity: data);
          productList.addAll(data);
        },
      );
    } catch (e) {
      state = ProductState.error(message: 'Failed to Load product');
    }
  }

  Future<void> deleteItem(String id)async{
    try {
      state = const ProductState.loading();
      final response = await deleteItemUseCase.call(id);
      response.fold(
            (e) {
          state = ProductState.error(message: e.message ?? "");
        },
            (data) {
          productList.removeWhere((element) => element.id==id,);
          state = ProductState.loaded(entity:productList);
          showSnackbar('Entity Deleted Successfully', Colors.green);
        },
      );
    } catch (e) {
      state = ProductState.error(message: 'Failed to Load product');
    }
  }
}
