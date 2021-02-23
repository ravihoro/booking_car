import 'package:booking_car/pages/driver/driver_home_page.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';
import 'package:db_repository/db_repository.dart';
import 'package:provider/provider.dart';

class NewBookings extends StatelessWidget {
  final List<Booking> bookings;

  NewBookings({this.bookings});

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
                name: booking.customerName,
                origin: booking.origin,
                destination: booking.destination,
                date: booking.date,
                accept: () async {
                  bool val = await dbRepository.updateBookingStatus(
                    email: booking.email,
                    customerEmail: booking.customerEmail,
                    date: booking.date,
                    status: 'accepted',
                  );
                  if (val) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Message"),
                          content: Text(
                            "Booking accepted",
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DriverHomePage()));
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'Action failed.',
                    )));
                  }
                },
                reject: () async {
                  bool val = await dbRepository.updateBookingStatus(
                    email: booking.email,
                    customerEmail: booking.customerEmail,
                    date: booking.date,
                    status: 'rejected',
                  );
                  if (val) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Message"),
                          content: Text(
                            "Booking rejected",
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DriverHomePage()));
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'Action failed.',
                    )));
                  }
                },
              );
            },
          );
  }
}
