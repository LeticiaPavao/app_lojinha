//& Imports packages
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
//& Imports providers
import 'package:provider/provider.dart';
import 'package:app_lojinha/providers/auth_provider.dart';
import 'package:app_lojinha/providers/cart_provider.dart';
//& Imports views
import 'home_page.dart';
import 'package:app_lojinha/views/auth/login_page.dart';
import 'package:app_lojinha/views/user/cadastro_view.dart';
//& Imports services
import 'package:app_lojinha/services/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationService notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['API_URL']!,
    anonKey: dotenv.env['API_KEY']!,
  );

  WebViewPlatform.instance = WebWebViewPlatform();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Vendas',
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/cadastro': (context) => RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
