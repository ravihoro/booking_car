import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';
import 'package:db_repository/db_repository.dart';

class RejectedBookings extends StatelessWidget {
  final List<Booking> bookings;

  RejectedBookings({this.bookings});

  @override
  Widget build(BuildContext context) {
    return bookings.length == 0
        ? Center(
            child: Text('No rejected bookings'),
          )
        : ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              Booking booking = bookings[index];
              return CustomCard(
                name: booking.name,
                origin: booking.origin,
                destination: booking.destination,
                date: booking.date,
              );
            },
          );
  }
}
