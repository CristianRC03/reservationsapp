import 'package:booking_app/domain/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationsView extends StatefulWidget {
  const ReservationsView({super.key});

  @override
  State<ReservationsView> createState() => _ReservationsViewState();
}

class _ReservationsViewState extends State<ReservationsView> {
  var userId = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';
      final provider = Provider.of<ReservationProvider>(context, listen: false);
      provider.getReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Reservaciones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InfoCard(
                  title: 'Pendientes',
                  value: reservationProvider
                      .countReservationsByStatus('pending', userId: userId )
                      .toString(),
                  color: Colors.orange,
                ),
                _InfoCard(
                  title: 'Confirmadas',
                  value: reservationProvider
                      .countReservationsByStatus('confirm', userId: userId)
                      .toString(),
                  color: Colors.green,
                ),
                _InfoCard(
                  title: 'Canceladas',
                  value: reservationProvider
                      .countReservationsByStatus('cancelled', userId: userId)
                      .toString(),
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Últimas Reservaciones',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: reservationProvider.getReservationsByUser(userId).length,
                itemBuilder: (context, index) {
                  final reservation = reservationProvider.getReservationsByUser(userId)[index];
                  return Card(
                    child: ListTile(
                      title: Text(reservation.property.title),
                      subtitle: Text(
                          'Huéspedes: ${reservation.guests} | ${reservation.startDate.toLocal().toString().split(' ')[0]} - ${reservation.endDate.toLocal().toString().split(' ')[0]}'),
                      leading: Icon(
                        Icons.home,
                        color: _getStatusColor(reservation.status),
                      ),
                      trailing: Text(reservation.status.capitalize()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirm':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
