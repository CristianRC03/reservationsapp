import 'package:booking_app/presentation/screens/login_register/login/login_screen.dart';
import 'package:booking_app/presentation/screens/login_register/register/register_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: "/home/0",
  routes: [
    // Ruta para Home/Login
    GoRoute(
      path: "/home/:view",
      builder: (context, state) {
        final viewIndex = int.parse(state.pathParameters["view"] ?? "0");
        return LoginScreen(viewIndex: viewIndex);
      },
    ),
    // Ruta para Registro
    GoRoute(
      path: "/Register",
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),
  ],
);
