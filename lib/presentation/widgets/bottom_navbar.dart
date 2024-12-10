import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatelessWidget {
  final int index;
  const BottomNavbar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: index, // usar el valor del parámetro index
      onTap: (value) {
        print("El valor es ${value.toString()}");
        switch (value) {
          case 0:
            // Navegar a home view
            context.go("/home/0");
            break;
          case 1:
            // Navegar a otra vista
            context.go("/home/1");
            break;
          case 2:
            // Navegar a otra vista
            context.go("/home/2");
            break;
          
        }
      },
      color: Colors.white,
      items: const [
        Icon(Icons.home, color: Colors.black),
        Icon(Icons.map_outlined, color: Colors.black),
        Icon(Icons.home_work_outlined, color: Colors.black),
      ],
    );
  }
}

