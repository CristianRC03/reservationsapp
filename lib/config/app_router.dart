import 'package:booking_app/presentation/screens/home/home_screen.dart';

import 'package:booking_app/presentation/screens/login_register/login/login_screen.dart';
import 'package:booking_app/presentation/screens/login_register/register/register_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: "/login",
  routes: [
    // Ruta para Home/Login
    GoRoute(
      path: "/login",
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    // Ruta para Registro
    GoRoute(
      path: "/Register",
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),
    


    GoRoute(path: "/home/:view",
      builder: (context, state) {
        final viewIndex = state.pathParameters['view'] ?? "0";
        return HomeScreen(viewIndex: int.parse(viewIndex));
      }
    ),
  ],
);
