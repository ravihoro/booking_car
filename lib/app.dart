import './login/pages/login_page.dart';
import './splash.dart';
//import 'package:bloc_login/sign_up/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './authentication/bloc/authentication_bloc.dart';
import 'package:db_repository/db_repository.dart';
import './pages/customer/customer_home_page.dart';
import './pages/driver/driver_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final DbRepository dbRepository;

  App(
      {Key key,
      @required this.authenticationRepository,
      @required this.dbRepository})
      : assert(authenticationRepository != null),
        assert(dbRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authenticationRepository,
        ),
        RepositoryProvider.value(
          value: dbRepository,
        ),
      ],
      child: BlocProvider<AuthenticationBloc>(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  // Future<bool> isLoggedIn() async {
  //   print("islogged in called");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool("isLoggedIn") ?? false;
  // }

  // Future<String> email() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString("email") ?? "";
  // }

  // Future<String> password() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString("password") ?? "";
  // }

  // _login() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String email = prefs.getString('email');
  //   String password = prefs.getString('password');

  //   AuthenticationRepository authenticationRepository =
  //       Provider.of<AuthenticationRepository>(context, listen: false);

  //   await authenticationRepository.login(email: email, password: password);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        // return FutureBuilder(
        //   future: isLoggedIn(),
        //   builder: (context, snapshot) {
        //     print(snapshot.data);
        //     if (!snapshot.hasData) {
        //       _navigator.push(SplashPage.route());
        //     }
        //     if (snapshot.hasData) {
        //       bool isLoggedIn = snapshot.data;
        //       if (isLoggedIn) {
        //         _login();
        //       }
        //       return BlocListener<AuthenticationBloc, AuthenticationState>(
        //         listener: (context, state) async {
        //           if (!isLoggedIn || state.user == User.empty) {
        //             _navigator.pushAndRemoveUntil<void>(
        //                 LoginPage.route(), (route) => false);
        //           } else {
        //             if (state.user.userType == 'customer') {
        //               _navigator.pushAndRemoveUntil<void>(
        //                   CustomerHomePage.route(), (route) => false);
        //             } else {
        //               _navigator.pushAndRemoveUntil<void>(
        //                   DriverHomePage.route(), (route) => false);
        //             }
        //             // _navigator.pushAndRemoveUntil<void>(
        //             //     HomePage.route(), (route) => false);
        //           }
        //         },
        //         child: child,
        //       );
        //     }
        //   },
        // );
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.user == User.empty) {
              _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(), (route) => false);
            } else {
              if (state.user.userType == 'customer') {
                _navigator.pushAndRemoveUntil<void>(
                    CustomerHomePage.route(), (route) => false);
              } else {
                _navigator.pushAndRemoveUntil<void>(
                    DriverHomePage.route(), (route) => false);
              }
              // _navigator.pushAndRemoveUntil<void>(
              //     HomePage.route(), (route) => false);
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
