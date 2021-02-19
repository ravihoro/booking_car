import 'package:booking_car/pages/pages.dart';
import 'package:flutter/material.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:booking_car/widgets/driver_search.dart';

class CustomerHomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CustomerHomePage());
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
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Customer'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DriverSearch());
                },
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.amber,
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
