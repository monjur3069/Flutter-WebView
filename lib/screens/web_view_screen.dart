import 'package:flutter/material.dart';
import 'package:web_view_app/screens/home_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  static const String routeName = '/web_view_screen';

  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  late String url;

  @override
  void didChangeDependencies() async {
    url = ModalRoute.of(context)!.settings.arguments.toString();

    Future.delayed(const Duration(seconds: 5));
    controller = WebViewController()..loadRequest(Uri.parse(url));
    // ..loadRequest(Uri.parse('https://www.facebook.com/'));
    controller
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        setState(() {
          loadingPercentage = 0;
        });
      }, onProgress: (progress) {
        setState(() {
          loadingPercentage = progress;
        });
      }, onPageFinished: (url) {
        setState(() {
          loadingPercentage = 100;
        });
      }))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("SnackBar", onMessageReceived: (message) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message.message)));
      });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    Future<dynamic> buildShowDialog() {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xff006A70),
              title: const Text(
                'No Back History Found',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Do you wanna go home page?',
                style: TextStyle(color: Colors.white),
              ),
              surfaceTintColor: Colors.transparent,
              actionsAlignment: MainAxisAlignment.center,
              scrollable: true,
              actions: [
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.green)),
                    onPressed: ()=> Navigator.pushReplacementNamed(context, HomePage.routeName),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.red)),
                    onPressed: ()=> Navigator.of(context).pop(),
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xffC5E6E8),
        toolbarHeight: 50,
        leading: IconButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, HomePage.routeName),
            icon: Image.asset(
              'images/home.PNG',
              height: 50,
              width: 50,
            )),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff006A70),
              ),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  buildShowDialog();
                  return;
                }
              }),
          IconButton(
              icon: const Icon(
                Icons.replay,
                color: Color(0xff006A70),
              ),
              onPressed: () async {
                controller.reload();
              }),
          IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xff006A70),
              ),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                if (await controller.canGoForward()) {
                  await controller.goForward();
                } else {
                  messenger.showSnackBar(const SnackBar(
                    content: Text(
                      'No Forward History Found',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: Color(0xff006A70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                  ));
                  return;
                }
              }),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          if (await controller.canGoBack()) {
            await controller.goBack();
          } else {
              buildShowDialog();

            return;
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: controller),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  color: const Color(0xff006A70),
                  value: loadingPercentage / 100.0,
                ),
            ],
          ),
        ),
      ),
    );

  }

}
