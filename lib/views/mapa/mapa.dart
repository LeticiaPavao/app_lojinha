import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; 

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final String htmlContent = '''
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { margin:0; padding:0; overflow:hidden; }
            iframe { width:100vw; height:100vh; border:0; }
          </style>
        </head>
        <body>
          <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d5935.524885485997!2d-49.96518878792742!3d-20.41805901478631!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x94bd593c914b944d%3A0x2c4b26a57846abfc!2sEscola%20T%C3%A9cnica%20Estadual%20Frei%20Arnaldo%20Maria%20de%20Itaporanga%20-%20N%C3%BAcleo%20Urbano!5e0!3m2!1spt-BR!2sbr!4v1773686485809!5m2!1spt-BR!2sbr" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
        </body>
      </html>
    ''';

    _controller = WebViewController()
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localização da Loja'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}