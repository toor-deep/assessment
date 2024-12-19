import 'package:flutter/material.dart';
import 'package:flutterriverpod/features/product_list/domain/entity/product_entity.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../design-system/styles.dart';

import 'item_detail_view.dart';

class ItemListScreen extends ConsumerStatefulWidget {
  static String path = '/list_view';
  static String name = 'list_view';

  const ItemListScreen({super.key});

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends ConsumerState<ItemListScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(productNotifierProvider.notifier).getList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifierProvider);
    final authState = ref.watch(authNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('List View'),
        actions: [
          GestureDetector(
            onTap: () {
              context.pushNamed('profile');
            },
            child: CircleAvatar(
              child: authState.authUser.photoURL == null ||
                      authState.authUser.photoURL!.isEmpty
                  ? Text(
                      (authState.authUser.email ?? "").isNotEmpty
                          ? (authState.authUser.email??'')[0].toUpperCase()
                          : '',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
                    )
                  : Image(image: NetworkImage(authState.authUser.photoURL!)),
            ),
          )
        ],
      ),
      body: state.when(
        initial: () => _buildUi(context),
        loading: () => _buildLoadingUi(),
        loaded: (products) => _buildUi(context, products: products),
        error: (message) => _buildErrorUi(message),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('addItem').then(
            (value) {
              if (value == true) {
                ref.read(productNotifierProvider.notifier).getList();
              }
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLoadingUi() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorUi(String message) {
    return Center(child: Text('Error: $message'));
  }

  Widget _buildUi(BuildContext context, {List<ProductEntity>? products}) {
    if (products == null || products.isEmpty) {
      return const Center(child: Text("No items available"));
    }

    return Padding(
      padding: Paddings.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ItemDetailScreen(item: item)));
                        },
                        contentPadding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        tileColor: Colors.pink[50],
                        title: Text(item.title),
                        subtitle: Text(item.description),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showChangeStatusSheet(item.id, context: context);
                        },
                        child: const CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  showChangeStatusSheet(String id, {required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure want to perform this action?'),
            content: const Text('The Item will be removed'),
            actions: [
              FilledButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red)),
                  onPressed: () {
                    ref.watch(productNotifierProvider.notifier).deleteItem(id);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Yes',
                  )),
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}
