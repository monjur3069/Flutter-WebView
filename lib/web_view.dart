import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    controller = WebViewController()
      ..loadRequest(Uri.parse('https://www.google.com/'))
    ;
    controller
      ..setNavigationDelegate(NavigationDelegate(
            onPageStarted: (url) {setState(() {loadingPercentage = 0;});},
            onProgress: (progress) {setState(() {
              loadingPercentage = progress;
            });},
            onPageFinished: (url) {setState(() {loadingPercentage = 100;});}))
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..addJavaScriptChannel("Snacbar", onMessageReceived: (message){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
    })
    ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            if(loadingPercentage<100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              )
          ],
        ),
      ),
    );
  }
}
