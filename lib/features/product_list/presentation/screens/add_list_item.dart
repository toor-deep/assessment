import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterriverpod/features/product_list/data/data_source/product_data_source.dart';
import 'package:flutterriverpod/shared/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';

class AddItemScreen extends HookConsumerWidget {
  static String path = '/addItem';
  static String name = 'addItem';

  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New Book'),
      ),
      body: state.when(
        initial: () => _buildUi(context, ref),
        loading: () => _buildUi(context, ref, isLoading: true),
        loaded: (message) => _buildUi(context, ref, isLoading: false),
        error: (message) => _buildUi(context, ref, errorMessage: message),
      ),
    );
  }

  Widget _buildUi(
      BuildContext context,
      WidgetRef ref, {
        bool isLoading = false,
        String? errorMessage,
      }) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController();
    final quantityController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacing.hmed,
            TextFormField(
              controller: titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Book title';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Book Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacing.hmed,
            TextFormField(
              controller: descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Book description';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Book Price',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacing.hmed,
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter book price';
                }
                return null;
              },
              controller: priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text(
              'Book Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacing.hmed,
            TextFormField(
              controller: categoryController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter book category';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quantity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacing.hmed,
            TextFormField(
              controller: quantityController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter item quantity';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await ref.read(productNotifierProvider.notifier).addProduct(
                        ItemInputParams(
                          title: titleController.text,
                          description: descriptionController.text,
                          price: priceController.text,
                          category: categoryController.text,
                          quantity: int.parse(quantityController.text),
                        ));

                    context.pop(true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator()
                    : const Text('Save Book', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class Item {
  final String id;
  final String title;
  final String description;
  final String price;
  final String category;
  final int quantity;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.quantity,
  });
}
