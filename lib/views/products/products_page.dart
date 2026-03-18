//& Imports packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//& Imports models
import 'package:app_lojinha/models/product.dart';
//& Imports widgets
import 'package:app_lojinha/widgets/product_tile.dart';
//& Imports providers
import 'package:app_lojinha/providers/cart_provider.dart';
//& Imports services
import 'package:app_lojinha/services/services/product_service.dart';
//& Imports views
import 'package:app_lojinha/views/products/register_product_page.dart';
import 'package:app_lojinha/views/products/update_product_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final productService = ProductService();
  late Future<List<Product>> _futureProducts;

  Future<void> _updateProduct(String productId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductPage(productId: productId),
      ),
    );

    if (result == true) {
      setState(() {
        _futureProducts = productService.getActiveProducts();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _futureProducts = productService.getActiveProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterProductPage(),
            ),
          );

          setState(() {
            _futureProducts = productService.getActiveProducts();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              return ProductTile(
                product: products[index],
                onAdd: () {
                  cart.add(products[index]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${products[index].name} adicionado ao cart',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onEdit: () => _updateProduct(products[index].id),
              );
            },
          );
        },
      ),
    );
  }
}
