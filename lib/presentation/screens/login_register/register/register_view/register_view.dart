import 'package:booking_app/domain/datasources/auth_datasource.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final roles = ['user', 'host'];
    String selectedRole = 'user';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Crear una cuenta nueva',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Campo de texto para el nombre
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            // Campo de texto para confirmar la contraseña
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirmar Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // Dropdown para seleccionar el rol
            DropdownButtonFormField(
              value: selectedRole,
              items: roles
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) {
                // Actualizar el rol seleccionado
                selectedRole = value ?? 'user';
              },
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
            const SizedBox(height: 20),
            // Botón para registrar
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                final confirmPassword = confirmPasswordController.text;

                // Validación simple
                if (email.isEmpty ||
                    password.isEmpty ||
                    confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, complete todos los campos.'),
                    ),
                  );
                } else if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Las contraseñas no coinciden.'),
                    ),
                  );
                } else {
                  // Aquí puedes agregar la lógica para registrar al usuario.
                  AuthDatasource authDatasource = AuthDatasource();
                  await authDatasource.register(
                    nameController.text,
                    email,
                    password,
                    selectedRole,
                  );
                  GoRouter.of(context).go('/home/0');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cuenta creada exitosamente.'),
                    ),
                  );
                }
              },
              child: const Text('Crear Cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
