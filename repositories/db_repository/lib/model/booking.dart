class Booking {
  final String email;
  final String name;
  final String customerName;
  final String customerEmail;
  final String origin;
  final String destination;
  final String status;
  final DateTime date;
  Booking({
    this.email,
    this.name,
    this.customerName,
    this.customerEmail,
    this.origin,
    this.destination,
    this.status,
    this.date,
  });

  static Booking fromJson(Map<String, dynamic> map) {
    return Booking(
      email: map['email'],
      name: map['name'],
      customerName: map['customer_name'],
      customerEmail: map['customer_email'],
      origin: map['origin'],
      destination: map['destination'],
      status: map['status'],
      date: DateTime.parse(map['date']),
    );
  }
}
