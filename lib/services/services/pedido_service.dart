import 'package:app_padrao/models/order.dart';

class PedidoService {
  static final List<Order> _pedidos = [];

  Future<void> salvarPedido(Order pedido) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _pedidos.add(pedido);
    print('Pedido salvo: ${pedido.orderNumber}');
  }

  List<Order> getPedidos(String userId) {
    return _pedidos.where((p) => p.userId == userId).toList();
  }
}
