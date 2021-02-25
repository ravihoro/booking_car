import 'package:booking_car/pages/customer/customer_home_page.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';
import 'package:db_repository/db_repository.dart';
import 'package:provider/provider.dart';

class NewBookings extends StatelessWidget {
  final List<Booking> bookings;

  NewBookings({this.bookings});

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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CustomerHomePage()));
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DbRepository dbRepository = context.read<DbRepository>();

    return bookings.length == 0
        ? Center(
            child: Text('No new bookings'),
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
                cancel: () async {
                  bool val = await dbRepository.deleteBooking(
                    email: booking.email,
                    customerEmail: booking.customerEmail,
                    date: booking.date,
                    status: 'unknown',
                  );
                  if (val) {
                    _dialog(context, 'Booking cancelled');
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Booking cancellation failed.',
                      ),
                    ));
                  }
                },
              );
            },
          );
  }
}
