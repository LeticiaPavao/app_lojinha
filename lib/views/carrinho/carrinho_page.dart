import 'package:app_padrao/providers/auth_provider.dart';
import 'package:app_padrao/providers/carrinho_provider.dart';
import 'package:app_padrao/services/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carrinho = Provider.of<CarrinhoProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    if (carrinho.itens.isEmpty) {
      return const Center(child: Text('Seu carrinho está vazio'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: carrinho.itens.length,
            itemBuilder: (ctx, index) {
              final produto = carrinho.itens[index];
              return ListTile(
                leading: produto.imagemUrl != null
                    ? Image.network(produto.imagemUrl!)
                    : const Icon(Icons.broken_image, size: 50),
                title: Text(produto.nome),
                subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_shopping_cart),
                  onPressed: () => carrinho.remover(produto),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: R\$ ${carrinho.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await carrinho.finalizarPedido(auth.user!.id);

                    final notificationService = NotificationService();
                    await notificationService.showNotification(
                      title: 'Pedido Confirmado',
                      body: 'Seu pedido foi realizado com sucesso!',
                      payload: 'order_success',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pedido realizado com sucesso!'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Erro: $e')));
                  }
                },
                child: const Text('Finalizar Pedido'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
