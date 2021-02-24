import 'package:db_repository/db_repository.dart';
import 'package:flutter/material.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './car_details.dart';
import '../pages.dart';

class DriverHomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => DriverHomePage());
  }

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  DbRepository dbRepository;
  String email;

  Future<List<Booking>> newBookings;
  Future<List<Booking>> acceptedBookings;
  Future<List<Booking>> rejectedBookings;

  @override
  void initState() {
    super.initState();
    dbRepository = context.read<DbRepository>();
    email = context.read<AuthenticationBloc>().state.user.email;
    newBookings = getNewBookings();
    acceptedBookings = getAcceptedBookings();
    rejectedBookings = getRejectedBookings();
  }

  Future<List<Booking>> getNewBookings() async {
    var unknown = await dbRepository.getBookings(
        email: email, status: "unknown", date: DateTime.now());
    return unknown;
  }

  Future<List<Booking>> getAcceptedBookings() async {
    var accepted =
        await dbRepository.getBookings(email: email, status: "accepted");
    return accepted;
  }

  Future<List<Booking>> getRejectedBookings() async {
    var rejected =
        await dbRepository.getBookings(email: email, status: "rejected");
    return rejected;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
        body: FutureBuilder(
          future:
              Future.wait([newBookings, acceptedBookings, rejectedBookings]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return TabBarView(
              children: [
                NewBookings(
                  bookings: snapshot.data[0],
                ),
                AcceptedBookings(
                  bookings: snapshot.data[1],
                ),
                RejectedBookings(
                  bookings: snapshot.data[2],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
