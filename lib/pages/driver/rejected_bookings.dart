import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';

class RejectedBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          name: "Ravi",
          location: "Ranchi",
          date: DateTime.now(),
          time: DateTime.now(),
          accept: () {
            print('Accepted');
          },
        ),
        CustomCard(
          name: "John",
          location: "Kamdara",
          date: DateTime.now(),
          time: DateTime.now(),
          accept: () {
            print('Accepted');
          },
        ),
        CustomCard(
          name: "Mark",
          location: "Lohardaga",
          date: DateTime.now(),
          time: DateTime.now(),
          accept: () {
            print('Accepted');
          },
        ),
        CustomCard(
          name: "Horo",
          location: "Itki",
          date: DateTime.now(),
          time: DateTime.now(),
          accept: () {
            print('Accepted');
          },
        ),
      ],
    );
  }
}
