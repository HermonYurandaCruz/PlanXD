import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'views/telas/home_screen.dart';
import 'views/telas/projetos_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/projetos',
        builder: (context, state) => ProjetosScreen(),
      ),
    ],
  );


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Flutter Navigation',
    );
  }
}
