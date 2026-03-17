import 'package:app_padrao/models/produto.dart';
import 'package:app_padrao/providers/carrinho_provider.dart';
import 'package:app_padrao/services/services/produto_service.dart';
import 'package:app_padrao/views/produtos/cadastro_produto_page.dart';
import 'package:app_padrao/views/produtos/editar_produto_page.dart';
import 'package:app_padrao/widgets/produto_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final produtoService = ProdutoService();
  late Future<List<Produto>> _futureProdutos;


  Future<void> _editarProduto(String produtoId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarProdutoPage(produtoId: produtoId),
      ),
    );

    if (result == true) {
      setState(() {
        _futureProdutos = produtoService.getProdutosAtivos();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _futureProdutos = produtoService.getProdutosAtivos();
  }

  @override
  Widget build(BuildContext context) {
    final carrinho = Provider.of<CarrinhoProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroProdutoPage(),
            ),
          );

          setState(() {
            _futureProdutos = produtoService.getProdutosAtivos();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Produto>>(
        future: _futureProdutos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado'));
          }

          final produtos = snapshot.data!;
          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (ctx, index) {
              return ProdutoTile(
                produto: produtos[index],
                onAdicionar: () {
                  carrinho.adicionar(produtos[index]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${produtos[index].nome} adicionado ao carrinho',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onEditar: () => _editarProduto(produtos[index].id),
              );
            },
          );
        },
      ),
    );
  }
}
