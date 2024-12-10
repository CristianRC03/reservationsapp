import 'package:booking_app/config/app_router.dart';
import 'package:booking_app/domain/datasources/reservations_datasource.dart';
import 'package:booking_app/domain/provider/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ReservationProvider(datasource: ReservationsDatasource()))
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Material App',
      ),
    );
  }
}