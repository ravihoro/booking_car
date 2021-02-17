class Driver {
  final String name;
  final String email;
  Driver({this.name, this.email});

  static Driver fromJson(Map<String, dynamic> map) {
    return Driver(
      name: map['name'],
      email: map['email'],
    );
  }
}
