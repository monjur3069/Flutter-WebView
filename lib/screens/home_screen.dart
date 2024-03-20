import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_view_app/screens/web_view_screen.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController urlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: const Color(0xff006A70),
                  title: const Text(
                    'Are you sure to exit?',
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
                        onPressed: ()=> SystemNavigator.pop(),
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
        },
        child: SafeArea(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                          child: Image.asset(
                        'images/img.jpg',
                        fit: BoxFit.cover,
                      ))),
                  const SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            controller: urlController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FittedBox(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff006A70),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.public,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          'https://',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              fillColor: Colors.white,
                              filled: true,
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(.5),
                              ),
                              hintText: 'Write or paste your Url here',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field must not be empty';
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        if (!urlController.text.startsWith("https://www.")) {
                          if (urlController.text.startsWith("https://")) {
                            urlController.text =
                                "https://www.${urlController.text.substring(8)}";
                          } else if (urlController.text.startsWith("www.")) {
                            urlController.text =
                                "https://www.${urlController.text.substring(4)}";
                          } else {
                            urlController.text =
                                "https://www.${urlController.text}";
                          }
                        }
                        Navigator.pushReplacementNamed(
                            context, WebViewPage.routeName,
                            arguments:
                                urlController.text.toString().toLowerCase());
                      },
                      child: Container(
                        width: 200,
                        alignment: Alignment.center,
                        height: 50,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.1, 0.5, 0.5, 0.9],
                            colors: [
                              const Color(0xff006A70).withOpacity(0.8),
                              // Base color
                              const Color(0xff006A70).withOpacity(0.7),
                              // Lighter shade
                              const Color(0xff006A70).withOpacity(0.6),
                              // Even lighter shade
                              const Color(0xff006A70).withOpacity(0.5),
                            ],
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: const Text(
                          'Submit',
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
