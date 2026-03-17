import 'order_item.dart';

class Order {
  final String orderNumber;
  final String? customerId; // pode ser null se cliente não cadastrado
  final String? userId; // vendedor que registrou
  final DateTime orderDate;
  final double totalAmount;
  final String status; // pending, confirmed, preparing, shipped, delivered, cancelled
  final String? paymentMethod;
  final String? paymentStatus; // pending, paid, refunded, cancelled
  final String? deliveryAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem>? items; // opcional, para carregar junto

  Order({
    required this.orderNumber,
    this.customerId,
    this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.deliveryAddress,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderNumber: json['order_number'] as String,
      customerId: json['customer_id'] as String?,
      userId: json['user_id'] as String?,
      orderDate: DateTime.parse(json['order_date']),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String?,
      paymentStatus: json['payment_status'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_number': orderNumber,
      'customer_id': customerId,
      'user_id': userId,
      'order_date': orderDate.toIso8601String(),
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'delivery_address': deliveryAddress,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}