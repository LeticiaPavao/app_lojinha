import 'package:flutter/material.dart';
import '../models/produto.dart';

class ProdutoTile extends StatelessWidget {
  final Produto produto;
  final VoidCallback onAdicionar;
  final VoidCallback? onEditar;

  const ProdutoTile({
    super.key,
    required this.produto,
    required this.onAdicionar,
    this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(
          produto.imagemUrl ?? 'https://via.placeholder.com/150',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image),
        ),
        title: Text(produto.nome),
        subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEditar,
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: onAdicionar,
            ),
          ],
        ),
      ),
    );
  }
}
