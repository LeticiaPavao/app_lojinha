//& Imports packages
import 'package:supabase_flutter/supabase_flutter.dart';
//& Imports models
import 'package:app_lojinha/models/product.dart';

class ProductService {
  final _supabase = Supabase.instance.client;

  late final _products = _supabase.from('products');

  Future<List<Product>> getActiveProducts() async {
    final response = await _products
        .select()
        .eq('is_active', true)
        .order('name');

    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<Product?> getProduct(String id) async {
    try {
      final response = await _products.select().eq('id', id).maybeSingle();

      if (response == null) return null;
      return Product.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<void> createProduct(Product product) async {
    final json = product.toJson();
    json.remove('id'); 
    await _products.insert(json);
  }

  Future<void> updateProduct(Product product) async {
    await _products.update(product.toJson()).eq('id', product.id);
  }

  Future<void> deleteProduct(String id) async {
    await _products.delete().eq('id', id);
  }
}
