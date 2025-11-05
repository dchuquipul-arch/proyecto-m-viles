class Appointment {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String service;
  final DateTime date;
  final String time; // HH:mm
  final String? notes;

  const Appointment({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.service,
    required this.date,
    required this.time,
    this.notes,
  });
}
