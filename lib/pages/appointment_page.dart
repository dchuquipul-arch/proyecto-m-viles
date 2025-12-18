import 'package:flutter/material.dart';
import 'package:hello_world/models/appointment.dart';
import 'package:hello_world/services/firebase_appointments_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// View: Lista de citas
class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Inicia sesión para ver tus citas')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Mis Citas'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: FirebaseAppointmentsService().getUserAppointmentsStream(
          user.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Es posible que ocurra un error de índice si es la primera vez, se maneja igual
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final appointments = snapshot.data ?? [];

          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_note, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes citas pendientes',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _navigateToCreate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Agendar nueva cita'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final apt = appointments[index];
              return _AppointmentCard(appointment: apt);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreate(context),
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add),
        label: const Text('Agendar'),
      ),
    );
  }

  void _navigateToCreate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAppointmentPage()),
    );
  }
}

// Widget auxiliar: Tarjeta de cita
class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A202C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(appointment.date),
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    appointment.time,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              appointment.service,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.white54,
                ),
                const SizedBox(width: 4),
                Text(
                  appointment.name,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Nota: ${appointment.notes}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }
}

// View: Formulario de creación
class CreateAppointmentPage extends StatefulWidget {
  const CreateAppointmentPage({super.key});

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _service;
  DateTime? _date;
  TimeOfDay? _time;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-llenar datos si el usuario tiene info en Auth? (Opcional)
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameCtrl.text = user.displayName ?? '';
      _emailCtrl.text = user.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.green,
            surface: Color(0xFF1A202C),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.green,
            surface: Color(0xFF1A202C),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '';
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false) ||
        _service == null ||
        _date == null ||
        _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos obligatorios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appointment = Appointment(
        id: '',
        userId: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        service: _service!,
        date: _date!,
        time: _formatTime(_time),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );

      final result = await FirebaseAppointmentsService().createAppointment(
        appointment,
      );

      if (!mounted) return;

      if (result != null) {
        Navigator.pop(context); // Volver a la lista
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita agendada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al agendar. Intenta de nuevo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputDecor = InputDecoration(
      labelStyle: TextStyle(color: Colors.white70),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
      ),
    );
    const textStyle = TextStyle(color: Colors.white);

    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      appBar: AppBar(
        title: const Text('Nueva Cita'),
        backgroundColor: const Color(0xFF1A202C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datos de contacto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameCtrl,
                style: textStyle,
                decoration: inputDecor.copyWith(labelText: 'Nombre y apellido'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa tu nombre'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                style: textStyle,
                decoration: inputDecor.copyWith(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().length < 6)
                    ? 'Teléfono inválido'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                style: textStyle,
                decoration: inputDecor.copyWith(
                  labelText: 'Correo electrónico',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Correo inválido' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Detalles de la cita',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _service,
                dropdownColor: const Color(0xFF1A202C),
                style: textStyle,
                items: const [
                  DropdownMenuItem(
                    value: 'Consulta de productos',
                    child: Text('Consulta de productos'),
                  ),
                  DropdownMenuItem(
                    value: 'Asesoría de belleza',
                    child: Text('Asesoría de belleza'),
                  ),
                  DropdownMenuItem(
                    value: 'Rutina de cuidado',
                    child: Text('Rutina de cuidado'),
                  ),
                ],
                onChanged: (v) => setState(() => _service = v),
                decoration: inputDecor.copyWith(labelText: 'Servicio'),
                validator: (v) => (v == null) ? 'Selecciona un servicio' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: _pickDate,
                      style: textStyle,
                      decoration: inputDecor.copyWith(
                        labelText: 'Fecha',
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.green,
                          ),
                          onPressed: _pickDate,
                        ),
                      ),
                      controller: TextEditingController(
                        text: _formatDate(_date),
                      ),
                      validator: (_) =>
                          (_date == null) ? 'Selecciona una fecha' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: _pickTime,
                      style: textStyle,
                      decoration: inputDecor.copyWith(
                        labelText: 'Hora',
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.access_time,
                            color: Colors.green,
                          ),
                          onPressed: _pickTime,
                        ),
                      ),
                      controller: TextEditingController(
                        text: _formatTime(_time),
                      ),
                      validator: (_) =>
                          (_time == null) ? 'Selecciona una hora' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesCtrl,
                style: textStyle,
                decoration: inputDecor.copyWith(labelText: 'Notas (opcional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Confirmar Cita',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
