class Product {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;
  final String category;
  final int stock;
  final DateTime? expiryDate;
  final String supplier;
  final double? weight;
  final String unitOfMeasure;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
    required this.category,
    required this.stock,
    this.expiryDate,
    required this.supplier,
    this.weight,
    required this.unitOfMeasure,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id:            json['id'] as String,
      name:          json['name'] as String,
      price:         (json['price'] as num).toDouble(),
      description:   json['description'] as String?,
      imageUrl:      json['image_url'] as String?,
      category:      json['category'] as String,
      stock:         json['stock'] as int,
      expiryDate:    json['expiry_date'] != null
                      ? DateTime.parse(json['expiry_date'])
                      : null,
      supplier:      json['supplier'] as String,
      weight:        json['weight'] != null
                      ? (json['weight'] as num).toDouble()
                      : null,
      unitOfMeasure: json['unit_of_measure'] as String,
      isActive:      json['is_active'] as bool,
      createdAt:     DateTime.parse(json['created_at']),
      updatedAt:     DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':              id,
      'name':            name,
      'price':           price,
      'description':     description,
      'image_url':       imageUrl,
      'category':        category,
      'stock':           stock,
      'expiry_date':     expiryDate?.toIso8601String(),
      'supplier':        supplier, 
      'weight':          weight,
      'unit_of_measure': unitOfMeasure,
      'is_active':       isActive,
      'created_at':      createdAt.toIso8601String(),
      'updated_at':      updatedAt.toIso8601String(),
    };
  }
}