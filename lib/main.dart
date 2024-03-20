import 'package:flutter/material.dart';
import 'package:web_view_app/screens/home_screen.dart';
import 'package:web_view_app/screens/web_view_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web View App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff006A70)),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (_)=> const HomePage(),
        WebViewPage.routeName : (_)=> const WebViewPage(),
      },
    );
  }
}

