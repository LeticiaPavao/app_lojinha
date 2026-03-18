//& Imports packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//& Imports providers
import 'package:app_lojinha/providers/auth_provider.dart';
//& Imports views
import 'package:app_lojinha/views/map/map.dart';
import 'package:app_lojinha/views/cart/cart_page.dart';
import 'package:app_lojinha/views/products/products_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _telas = <Widget>[
    ProductsPage(),
    CartPage(),
    Center(child: Text('Perfil (em construção)')),
  ];

  Future<void> _logout(BuildContext context, AuthProvider auth) async {
    await auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App de Vendas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context, auth),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (user != null)
              UserAccountsDrawerHeader(
                accountName: Text(user.email ?? 'Usuário'),
                accountEmail: Text(user.email ?? ''),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.purple),
                ),
              )
            else
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.purple),
                child: Center(
                  child: Text(
                    'App de Vendas',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Produtos'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Carrinho'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Mapa'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 2);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
                _logout(context, auth);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _telas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
