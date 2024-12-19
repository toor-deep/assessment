import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String price;
  final String category;
  final int quantity;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, title, description, price, category, quantity];

  ProductEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? price,
    String? category,
    int? quantity,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }

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

  factory ProductEntity.fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }
}
