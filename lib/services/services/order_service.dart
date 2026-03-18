//& Imports models
import 'package:app_lojinha/models/order.dart';

class OrderService {
  static final List<Order> _orders = [];

  Future<void> createOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _orders.add(order);
  }

  List<Order> getOrders(String userId) {
    return _orders.where((p) => p.userId == userId).toList();
  }
}
