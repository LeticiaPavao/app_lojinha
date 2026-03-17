class Produto {
  final String id;
  final String nome;
  final double preco;
  final String? descricao;
  final String? imagemUrl;
  final String categoria;
  final int estoque;
  final DateTime? dataValidade;
  final String fornecedor;
  final double? peso;
  final String unidadeMedida;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
    this.descricao,
    this.imagemUrl,
    required this.categoria,
    required this.estoque,
    this.dataValidade,
    required this.fornecedor,
    this.peso,
    required this.unidadeMedida,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] as String,
      nome: json['name'] as String,
      preco: (json['price'] as num).toDouble(),
      descricao: json['description'] as String?,
      imagemUrl: json['image_url'] as String?,
      categoria: json['category'] as String,
      estoque: json['stock'] as int,
      dataValidade: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      fornecedor: json['supplier'] as String,
      peso: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      unidadeMedida: json['unit_of_measure'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nome,
      'price': preco,
      'description': descricao,
      'image_url': imagemUrl,
      'category': categoria,
      'stock': estoque,
      'expiry_date': dataValidade?.toIso8601String(),
      'supplier': fornecedor,
      'weight': peso,
      'unit_of_measure': unidadeMedida,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}