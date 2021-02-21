import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';
import 'package:db_repository/db_repository.dart';

class NewBookings extends StatelessWidget {
  final List<Booking> bookings;

  NewBookings({this.bookings});

  @override
  Widget build(BuildContext context) {
    return bookings.length == 0
        ? Center(
            child: Text('No new bookings'),
          )
        : ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              Booking booking = bookings[index];
              return CustomCard(
                name: booking.customerName,
                origin: booking.origin,
                destination: booking.destination,
                date: booking.date,
              );
            },
          );
  }
}
