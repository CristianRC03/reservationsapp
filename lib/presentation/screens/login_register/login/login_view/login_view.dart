import 'package:booking_app/domain/datasources/auth_datasource.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Inicio de Sesión',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Campo de texto para el correo
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Campo de texto para la contraseña
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Botón para iniciar sesión
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;

                // Lógica de autenticación (por ejemplo, validar o iniciar sesión)
                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, complete todos los campos.'),
                    ),
                  );
                } else {
                  try {
                    // Iniciar sesión
                    AuthDatasource authDatasource = AuthDatasource();
                    await authDatasource.login(email, password);
                    GoRouter.of(context).go('/home/0');
                  } catch (e) {
                    print(e);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Correo o contraseña incorrectos.'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 16),
            // Enlace para recuperar contraseña
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/Register');
              },
              child: const Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
