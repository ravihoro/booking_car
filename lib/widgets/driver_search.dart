import 'package:flutter/material.dart';
import 'package:db_repository/db_repository.dart';
import 'package:provider/provider.dart';
import '../pages/customer/driver_details.dart';

class DriverSearch extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search drivers';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var dbRepository = Provider.of<DbRepository>(context);
    var driversList = dbRepository.getDrivers(name: query.trim());
    return FutureBuilder(
      future: driversList,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error fetching drivers",
            ),
          );
        }
        var list = snapshot.data;
        if (list.length == 0) {
          return Center(
            child: Text(
              "No drivers found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(list[index].name),
              subtitle: Text(list[index].email),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DriverDetails(
                          driver: list[index],
                        )));
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.grey[850],
    );
  }
}
