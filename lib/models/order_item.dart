class OrderItem {
  final String orderId;
  final String? productId;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double subtotal;
  final DateTime createdAt;

  OrderItem({
    required this.orderId,
    this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderId:     json['order_id'] as String,
      productId:   json['product_id'] as String?,
      productName: json['product_name'] as String,
      quantity:    (json['quantity'] as num).toDouble(),
      unitPrice:   (json['unit_price'] as num).toDouble(),
      subtotal:    (json['subtotal'] as num).toDouble(),
      createdAt:   DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id':     orderId,
      'product_id':   productId,
      'product_name': productName,
      'quantity':     quantity,
      'unit_price':   unitPrice,
      'subtotal':     subtotal,
      'created_at':   createdAt.toIso8601String(),
    };
  }
}