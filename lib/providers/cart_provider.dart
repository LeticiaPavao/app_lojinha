//& Imports packages
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//& Imports models
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _itens = [];

  List<Product> get itens => _itens;
  double get total => _itens.fold(0, (sum, item) => sum + item.price);

  void add(Product item) {
    _itens.add(item);
    notifyListeners();
  }

  void remove(Product item) {
    _itens.remove(item);
    notifyListeners();
  }

  void clear() {
    _itens.clear();
    notifyListeners();
  }

  Future<void> finishPedido(String userId) async {
    if (_itens.isEmpty) return;

    try {
      final supabase = Supabase.instance.client;

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

      final itemsToInsert = _itens.map((item) {
        return {
          'order_id': orderId,
          'product_id': item.id,
          'product_name': item.name,
          'quantity': 1, // TODO: permitir escolher quantidade
          'unit_price': item.price,
          'subtotal':
              item.price, // TODO: calcular subtotal com base na quantidade
        };
      }).toList();

      await supabase.from('order_items').insert(itemsToInsert);

      clear();
    } catch (e) {
      throw Exception('Erro ao processar pedido. Tente novamente.');
    }
  }
}
