import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/models/appointment.dart';

class FirebaseAppointmentsService {
  static final FirebaseAppointmentsService _instance = FirebaseAppointmentsService._internal();
  factory FirebaseAppointmentsService() => _instance;
  FirebaseAppointmentsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'appointments';

  // Crear una nueva cita
  Future<String?> createAppointment(Appointment appointment) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'name': appointment.name,
        'phone': appointment.phone,
        'email': appointment.email,
        'service': appointment.service,
        'date': Timestamp.fromDate(appointment.date),
        'time': appointment.time,
        'notes': appointment.notes,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error creando cita: $e');
      return null;
    }
  }

  // Obtener todas las citas como Stream
  Stream<List<Appointment>> getAllStream() {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return _appointmentFromFirestore(doc);
      }).toList();
    });
  }

  // Obtener citas (una sola vez)
  Future<List<Appointment>> getAll() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy('date', descending: false)
        .get();
    
    return snapshot.docs.map((doc) => _appointmentFromFirestore(doc)).toList();
  }

  // Obtener una cita por ID
  Future<Appointment?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return _appointmentFromFirestore(doc);
    } catch (e) {
      print('Error obteniendo cita: $e');
      return null;
    }
  }

  // Cancelar una cita
  Future<bool> cancelAppointment(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'status': 'cancelled',
      });
      return true;
    } catch (e) {
      print('Error cancelando cita: $e');
      return false;
    }
  }

  // Convertir documento de Firestore a Appointment
  Appointment _appointmentFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Appointment(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      service: data['service'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      notes: data['notes'],
    );
  }
}

