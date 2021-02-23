import 'package:booking_car/pages/customer/customer.dart';
import 'package:flutter/material.dart';
import './authentication/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import './pages/driver/car_details.dart';

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
            ),
            ListTile(
              title: Text('Customer'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Customer()));
              },
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Driver'),
            actions: [
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(Icons.car_rental),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              CarDetails(email: state.user.email)));
                    },
                  );
                },
              ),
            ],
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
            children: [],
          ),
        ),
      ),
    );
  }
}
