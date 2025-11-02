import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/src/views/admin_todo_page.dart';
import 'package:todo_app/src/views/home_page.dart';
import 'package:todo_app/src/views/login.dart';
import 'package:todo_app/src/views/user_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/login',
        routes: [

          GoRoute(
                path: '/register', //?   /register 
                name: 'signUp-todo',
                builder: (state, context) => UserPage(),
              ),
              
          GoRoute(
          path: '/login',
          name: 'login-todo',
          builder: (context, state) => const LoginPage(),
        ),

          GoRoute(
            path: '/todos',        
            name: 'todo-list',
            builder: (state, context) => HomePage(),
            routes: [
              GoRoute(
                path: '/create', //?   /todos/create
                name: 'new-todo',
                builder: (context, state) => AdminTodoPage(),
              ),
              GoRoute(
                path: '/:id', //?   /todos/124
                name: 'update-todo',
                builder: (context, state) {
                  print(state.pathParameters);
                  final todo = state.extra as Map<String, dynamic>;

                  return AdminTodoPage(todo: todo);
                },
              ),
            
            ],
          ),
          
        ],
      ),



      debugShowCheckedModeBanner: false,
      title: 'Todo - App',
      // initialRoute: '/',
      // home: AdminTodoPage(), // mi primer widget personalizado
      // routes: {
      //   '/': (context) => HomePage(),
      //   '/admin-todos': (context) => AdminTodoPage(),
      // },
    );


  }
}
