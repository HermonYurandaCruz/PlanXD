import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:plan_xd/views/telas/actividadeDatail_screen.dart';
import 'package:plan_xd/views/telas/updateProject.dart';
import 'package:plan_xd/views/telas/newProject_screen.dart';
import 'package:plan_xd/views/telas/projectDatail_screen.dart';
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
          path: '/update_project/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return EditarProjectoPage(id: id);
          }
          ),
      GoRoute(
        path: '/projetos',
        builder: (context, state) => ProjetosScreen(),
      ),
      GoRoute(path: '/new_project',
      builder:(context,state)=> AdicionarProjectoPage()
      ),
      GoRoute(
        path: '/detail_project/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DetalhesProjecto(id: id);
        }
      ),
      GoRoute(
          path: '/detail_atividade/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return DetalhesActidade(id: id);
          }
      ),
    ],
  );


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
