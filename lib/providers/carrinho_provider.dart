import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  List<Produto> _itens = [];

  List<Produto> get itens => _itens;
  double get total => _itens.fold(0, (sum, item) => sum + item.preco);

  void adicionar(Produto produto) {
    _itens.add(produto);
    notifyListeners();
  }

  void remover(Produto produto) {
    _itens.remove(produto);
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }

  Future<void> finalizarPedido(String userId) async {
    if (_itens.isEmpty) return;

    try {
      final supabase = Supabase.instance.client;

      // 1. Inserir o pedido e obter o ID gerado
      final orderResponse = await supabase
          .from('orders')
          .insert({
            'order_number': 'PED-${DateTime.now().millisecondsSinceEpoch}',
            'user_id': userId,
            'status': 'pending',
            'payment_status': 'pending',
            'total_amount': total,
          })
          .select('id')
          .single();

      final orderId = orderResponse['id'] as String;

      // 2. Preparar os itens do pedido
      final itemsToInsert = _itens.map((produto) {
        return {
          'order_id': orderId,
          'product_id': produto.id,
          'product_name': produto.nome,
          'quantity': 1, // se quiser quantidade variável, precisa ajustar
          'unit_price': produto.preco,
          'subtotal': produto.preco, // quantity * unit_price
        };
      }).toList();

      // 3. Inserir todos os itens de uma vez (melhor performance)
      await supabase.from('order_items').insert(itemsToInsert);

      // 4. Limpar o carrinho após sucesso
      limpar();

      print('✅ Pedido $orderId criado com sucesso!');
    } catch (e) {
      print('❌ Erro ao finalizar pedido: $e');
      throw Exception('Erro ao processar pedido. Tente novamente.');
    }
  }
}