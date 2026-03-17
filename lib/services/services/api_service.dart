import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_padrao/models/produto.dart';


class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map<Produto>((item) => Produto.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }
}