import 'package:booking_app/presentation/screens/home/map/map_view.dart';
import 'package:booking_app/presentation/screens/home/reservations/reservations_view.dart';
import 'package:booking_app/presentation/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  final int viewIndex;
  const HomeScreen({super.key, required this.viewIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: viewIndex, children: const [
        ReservationsView(),
        MapView(),
        Text("Otra vista"),
      ],

      ),
      bottomNavigationBar: BottomNavbar(index: viewIndex,),
    );
  }
}
