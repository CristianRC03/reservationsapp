import 'package:booking_app/presentation/screens/login_register/register/register_view/register_view.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RegisterView()
      );
  }
}