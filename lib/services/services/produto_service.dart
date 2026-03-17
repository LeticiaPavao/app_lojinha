import 'package:app_padrao/models/produto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProdutoService {
  final _supabase = Supabase.instance.client;

  late final _products = _supabase.from('products');

  Future<List<Produto>> getProdutosAtivos() async {
    final response = await _products
        .select()
        .eq('is_active', true)
        .order('name');

    return (response as List).map((json) => Produto.fromJson(json)).toList();
  }

  Future<Produto?> getProduto(String id) async {
    try {
      final response = await _products.select().eq('id', id).maybeSingle();

      if (response == null) return null;
      return Produto.fromJson(response);
    } catch (e) {
      print('Erro ao buscar produto: $e');
      return null;
    }
  }

  Future<void> criarProduto(Produto produto) async {
    final json = produto.toJson();
    json.remove('id'); 
    await _products.insert(json);
  }

  Future<void> atualizarProduto(Produto produto) async {
    await _products.update(produto.toJson()).eq('id', produto.id);
  }

  Future<void> deletarProduto(String id) async {
    await _products.delete().eq('id', id);
  }
}
