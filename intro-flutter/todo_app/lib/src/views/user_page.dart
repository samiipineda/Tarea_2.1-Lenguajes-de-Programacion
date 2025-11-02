import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/api/todos.dart';
import 'package:todo_app/src/shared/utils.dart';
import 'package:todo_app/src/widgets/app_text.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key, this.user});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFormat = RegExp(r'^[A-Za-z0-9._%+-]+@unah\.hn$');
  final passFormat = RegExp(r'^(?=.*[!@#\$%^&*(),.\-_;]).{6,}$');

  final FocusNode emailFocus = FocusNode();

  final Map<String, dynamic>? user;

  @override
  Widget build(BuildContext context) {
    //Id que me permite consultar a la BBDD la información actualziada
    final userID = GoRouterState.of(context).pathParameters['id'];

    if (user != null) {
      nameController.text = user!['nombre'];
      emailController.text = user!['email'];
      passwordController.text = user!['contrasena'];
      phoneController.text = user!['numero'];
      
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            user == null
                ? 'Registrate'
                : 'Editando datos del Usuario $userID',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
        child: Column(

          children: [

            TextRegistro(
             controller: nameController,
             focusNode: emailFocus, 
             maxLength: 50, 
             labelText: 'Nombre',
             ),

            SizedBox(height: 16),

            TextRegistro(
            controller: emailController, 
            maxLength: 30, 
            labelText: 'Correo institucional (@unah.hn)',
            keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 16),

            TextRegistro(controller: passwordController,
             maxLength: 50, labelText: 'Contraseña',
            ),

            SizedBox(height: 16),

            TextRegistro(controller: phoneController,
             maxLength: 12, labelText: 'No. Telefónico',
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),

            SizedBox(height: 16),

            TextButton(
                        onPressed: () {
                          context.goNamed('login-todo');      
                        },
                        child: const Text(
                          '¿Ya tienes usuario? Inicia Sesión',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
          ],

        ),
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () {
          //TODO: mostrar icono de carga usando gestores de estado
          if (nameController.text.isEmpty) {
            Utils.showSnackBar(
              context: context,
              title: "Ingrese el Nombre",
              color: Colors.red,
            );
            return;
          }
          if (emailController.text.isEmpty) {
            Utils.showSnackBar(
              context: context,
              title: "El email es obligatorio",
              color: Colors.red,
            );
            return;
          }

          if (!emailFormat.hasMatch((emailController.text))) {
            Utils.showSnackBar(
              context: context,
              title: "El email debe terminar con (@unah.hn)",
              color: Colors.red,
            );
            return;
          }

          if (passwordController.text.isEmpty) {
            Utils.showSnackBar(
              context: context,
              title: "Agregue una Contraseña",
              color: Colors.red,
            );
            return;
          }
          
          if (!passFormat.hasMatch((passwordController.text))) {
            Utils.showSnackBar(
              context: context,
              title: "La contraseña debe tener al menos 6 caracteres y un carácter especial",
              color: Colors.red,
            );
            return;
          }

          if (phoneController.text.isEmpty) {
            Utils.showSnackBar(
              context: context,
              title: "Ingrese Número Telefónico",
              color: Colors.red,
            );
            return;
          }
          
          final Map<String, dynamic> newUser = {
            'id': todoUsers.length + 1,
            'nombre': nameController.text,
            'email': emailController.text,
            'contrasena': passwordController.text,
            'numero': phoneController.text
          };

          if (userID == null) {
            todoUsers.add(newUser);
          } else {
            final indice = todoUsers.indexWhere(
              (user) => user['id'].toString() == userID,
            );
            todoUsers[indice] = newUser;
          }
          
          Utils.showSnackBar(
            context: context,
            title: "Usuario creada correctamente",
          );

          nameController.text = '';
          emailController.text = '';
          phoneController.text='';
          passwordController.text='';

          context.goNamed('login-todo');
        },
        child: Icon(Icons.add, color: Colors.blue[50]),
      ),
      
    );
  }
}


