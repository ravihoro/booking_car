import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';

class AcceptedBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          name: "Ravi",
          location: "Ranchi",
          date: DateTime.now(),
          time: DateTime.now(),
          reject: () {
            print('Rejected');
          },
        ),
        CustomCard(
          name: "John",
          location: "Kamdara",
          date: DateTime.now(),
          time: DateTime.now(),
          reject: () {
            print('Rejected');
          },
        ),
        CustomCard(
          name: "Mark",
          location: "Lohardaga",
          date: DateTime.now(),
          time: DateTime.now(),
          reject: () {
            print('Rejected');
          },
        ),
        CustomCard(
          name: "Horo",
          location: "Itki",
          date: DateTime.now(),
          time: DateTime.now(),
          reject: () {
            print('Rejected');
          },
        ),
      ],
    );
  }
}
