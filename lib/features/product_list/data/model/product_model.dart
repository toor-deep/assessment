import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/product_entity.dart';

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

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final String price;
  final String category;
  final int quantity;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'quantity': quantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, title, description, price, category, quantity];

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      description: description,
      title: title,
      price: price,
      category: category,
      quantity: quantity,
    );
  }
}
