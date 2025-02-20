import 'package:flutter/material.dart';
import 'package:himcops/drawer/pdrawer.dart';
// import 'package:himcops/police/phome.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EkycPage extends StatefulWidget {
  const EkycPage({super.key});

  @override
  State<EkycPage> createState() => _EkycPageState();
}

class _EkycPageState extends State<EkycPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      
      ..loadRequest(Uri.parse('https://himstaging2.hp.gov.in/aadhaar-service/ekyc'));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Know Your Customer",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 100, 233),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: PolAppDrawer(),
      body: WebViewWidget(controller: _controller),
    );
  }
}
