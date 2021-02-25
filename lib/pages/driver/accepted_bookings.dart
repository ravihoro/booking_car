import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';
import 'package:db_repository/db_repository.dart';
import 'package:provider/provider.dart';
import '../driver/driver_home_page.dart';

class AcceptedBookings extends StatelessWidget {
  final List<Booking> bookings;

  AcceptedBookings({this.bookings});

  _dialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(
            message,
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => DriverHomePage()));
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  _showScaffold(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
      'Action failed.',
    )));
  }

  @override
  Widget build(BuildContext context) {
    DbRepository dbRepository = context.read<DbRepository>();

    return bookings.length == 0
        ? Center(
            child: Text('No accepted bookings'),
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
                reject: DateTime.now().isAfter(booking.date)
                    ? null
                    : () async {
                        bool val = await dbRepository.updateBookingStatus(
                          email: booking.email,
                          customerEmail: booking.customerEmail,
                          date: booking.date,
                          status: 'rejected',
                        );
                        if (val) {
                          _dialog(context, 'Booking rejected');
                        } else {
                          _showScaffold(context);
                        }
                      },
              );
            },
          );
  }
}
