import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/api/todos.dart';
import 'package:todo_app/src/providers/todo_provider.dart';
import 'package:todo_app/src/shared/utils.dart';
import 'package:todo_app/src/widgets/item_list.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final todoProvider = TodoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          // 🔥 evita que la barra tape el contenido
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.red[50],
                      radius: 40,
                      child: Text(
                        'JA',
                        style: TextStyle(fontSize: 42, color: Colors.red[400]),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Juan Alvarenga'),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Inicio'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.important_devices),
                      title: Text('Importantes'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.warning),
                      title: Text('Críticas'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_month_rounded),
                      title: const Text('Calendario'),
                      onTap: () {
                        context.pop();
                        context.pushNamed('new-todo');
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text('Configuraciones'),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.calendar_month_rounded),
                      title: Text('Calendario'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(title: const Text('TODO-App')),
      body: FutureBuilder(
        future: todoProvider.getAllTodos(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(todoList[index]['id'].toString()),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    context.pushNamed(
                      'update-todo',
                      pathParameters: {'id': '${todoList[index]['id']}'},
                      extra: todoList[index],
                    );
                    return false;
                  }
                  return await Utils.showConfirm(
                    context: context,
                    confirmButton: () {
                      context.pop(todoList.remove(todoList[index]));
                    },
                  );
                },
                background: Container(
                  padding: const EdgeInsets.only(left: 16),
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red[50],
                      size: 30,
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Modificar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[50],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.edit_outlined,
                        color: Colors.blue[50],
                        size: 30,
                      ),
                    ],
                  ),
                ),
                child: ItemList(todo: todoList[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () => context.goNamed('new-todo'),
        child: Icon(Icons.add, color: Colors.blue[50]),
      ),
    );
  }
}
