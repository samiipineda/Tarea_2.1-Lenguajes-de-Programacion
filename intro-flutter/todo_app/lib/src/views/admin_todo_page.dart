import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/api/todos.dart';
import 'package:todo_app/src/shared/utils.dart';
import 'package:todo_app/src/widgets/text_Field.dart';

class AdminTodoPage extends StatelessWidget {
  AdminTodoPage({super.key, this.todo});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final FocusNode titleFocus = FocusNode();

  final Map<String, dynamic>? todo;

  @override
  Widget build(BuildContext context) {
    //Id que me permite consultar a la BBDD la información actualziada
    final todoId = GoRouterState.of(context).pathParameters['id'];

    if (todo != null) {
      titleController.text = todo!['title'];
      descriptionController.text = todo!['description'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          todo == null
              ? 'Creación de una nueva tarea'
              : 'Editando la tarea # $todoId',
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            PersonalizadoTextField(focusNode: titleFocus,controller: titleController,labelText: 'Titulo'),

            SizedBox(height: 16),

            //Widget Personalizado
            PersonalizadoTextField(controller: descriptionController,maxLines: 4,estiloDecoracion: 1,labelText: 'Descrpción'),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () {
          //TODO: mostrar icono de carga usando gestores de estado

          if (titleController.text.isEmpty) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       'Debe ingresar un titulo',
            //       style: TextStyle(color: Colors.red[50]),
            //     ),
            //     backgroundColor: Colors.red,
            //   ),
            // );

            Utils.showSnackBar(
              context: context,
              title: "El titulo es obligatorio",
              color: Colors.red,
            );

            return;
          }

          final Map<String, dynamic> newTodo = {
            'id': todoList.length + 1,
            'title': titleController.text,
            'description': descriptionController.text,
            'completed': false,
          };

          if (todoId == null) {
            todoList.add(newTodo);
          } else {
            final indice = todoList.indexWhere(
              (todo) => todo['id'].toString() == todoId,
            );

            todoList[indice] = newTodo;
          }
          
          Utils.showSnackBar(
            context: context,
            title: "Tarea creada correctamente",
          );

          titleController.text = '';
          descriptionController.text = '';

          context.pop();
        },
        child: Icon(Icons.add, color: Colors.blue[50]),
      ),
    );
  }
}
