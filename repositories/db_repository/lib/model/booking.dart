class Booking {
  final String email;
  final String customerName;
  final String customreEmail;
  final String origin;
  final String destination;
  final String status;
  final DateTime date;
  Booking({
    this.email,
    this.customerName,
    this.customreEmail,
    this.origin,
    this.destination,
    this.status,
    this.date,
  });

  static Booking fromJson(Map<String, dynamic> map) {
    return Booking(
      email: map['email'],
      customerName: map['customer_name'],
      customreEmail: map['customer_email'],
      origin: map['origin'],
      destination: map['destination'],
      status: map['status'],
      date: DateTime(map['date']),
    );
  }
}
