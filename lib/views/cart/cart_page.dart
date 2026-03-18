//& Imports packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//& Imports providers
import 'package:app_lojinha/providers/auth_provider.dart';
import 'package:app_lojinha/providers/cart_provider.dart';
//& Imports services
import 'package:app_lojinha/services/services/notification_service.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    if (cart.itens.isEmpty) {
      return const Center(child: Text('Seu carrinho está vazio'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.itens.length,
            itemBuilder: (ctx, index) {
              final item = cart.itens[index];
              return ListTile(
                leading: item.imageUrl != null
                    ? Image.network(item.imageUrl!)
                    : const Icon(Icons.broken_image, size: 50),
                title: Text(item.name),
                subtitle: Text('R\$ ${item.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_shopping_cart),
                  onPressed: () => cart.remove(item),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: R\$ ${cart.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await cart.finishPedido(auth.user!.id);

                    final notificationService = NotificationService();
                    await notificationService.showNotification(
                      title: 'Pedido Confirmado',
                      body: 'Seu pedido foi realizado com sucesso!',
                      payload: 'order_success',
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pedido realizado com sucesso!'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Erro ao finalizar pedido. Tente novamente.',
                          ),
                        ),
                      );
                    }
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
