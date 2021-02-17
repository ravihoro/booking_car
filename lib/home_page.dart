import 'package:booking_car/pages/pages.dart';
import 'package:flutter/material.dart';
import './authentication/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: null),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return ListTile(
                  trailing: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationLogoutRequested());
                  },
                );
              },
            )
          ],
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Driver'),
            bottom: TabBar(
              indicatorColor: Colors.amber,
              //unselectedLabelColor: Colors.amber,
              tabs: [
                Tab(
                  child: Text('New Bookings'),
                ),
                Tab(
                  child: Text('Accepted'),
                ),
                Tab(
                  child: Text('Rejected'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              NewBookings(),
              AcceptedBookings(),
              RejectedBookings(),
            ],
          ),
        ),
      ),
    );
  }
}
