import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/src/shared/autenticador.dart';
import '../widgets/app_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String message, {Color? color}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Autenticador.isLoggedIn.value = true;
      context.go('/todos');
    } else {
      _showSnack('Revisa los campos marcados', color: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    const brandColor = Colors.lightBlueAccent;
    final emailReg = RegExp(r'^[A-Za-z0-9._%+-]+@unah\.hn$');
    final passReg = RegExp(r'^(?=.*[!@#\$%^&*(),.\-_;]).{6,}$');

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.done_all_rounded,
                    size: 34,
                    color: brandColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'To-Do App',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: brandColor,
                      letterSpacing: .3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Login',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Correo institucional (@unah.hn)',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return 'Campo requerido';
                          if (!emailReg.hasMatch(value)) {
                            return 'El correo institucional debe terminar en @unah.hn';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Contraseña',
                        controller: _passCtrl,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        suffixIcon: IconButton(
                          tooltip: _obscure ? 'Mostrar' : 'Ocultar',
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return 'Campo requerido';
                          if (!passReg.hasMatch(value)) {
                            return 'Debe tener al menos 6 caracteres y un carácter especial';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          '¿No tienes cuenta? Crea tu usuario',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: brandColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Ingresar',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
