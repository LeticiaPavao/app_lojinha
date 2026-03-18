//& Imports packages
import 'package:flutter/material.dart';
//& Imports models
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback? onEdit;

  const ProductTile({
    super.key,
    required this.product,
    required this.onAdd,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(
          product.imageUrl ?? 'https://via.placeholder.com/150',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image),
        ),
        title: Text(product.name),
        subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
        trailing: SizedBox(
          width: 80,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit), 
                onPressed: onEdit,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: onAdd,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
