/// ============================================================
/// Appointment Model - Data class for Appointment Information
/// ============================================================
/// This model holds all the information about an appointment
/// booking between a patient and a doctor.
/// ============================================================

class AppointmentModel {
  // Unique ID for each appointment
  final String id;

  // Patient's full name
  final String patientName;

  // Patient's age
  final int age;

  // Patient's symptoms or medical problem
  final String symptoms;

  // Scheduled appointment date and time
  final String appointmentDate;

  // Patient's contact number
  final String contactNumber;

  // Doctor's name (who the patient is booking with)
  final String doctorName;

  // Doctor's ID (for linking to doctor)
  final String doctorId;

  // Current status of appointment
  // Possible values: 'Pending', 'Approved', 'Rejected'
  final String status;

  /// Constructor with named parameters
  AppointmentModel({
    required this.id,
    required this.patientName,
    required this.age,
    required this.symptoms,
    required this.appointmentDate,
    required this.contactNumber,
    required this.doctorName,
    required this.doctorId,
    this.status = 'Pending',
  });

  /// Creates a copy with updated status
  AppointmentModel copyWith({
    String? id,
    String? patientName,
    int? age,
    String? symptoms,
    String? appointmentDate,
    String? contactNumber,
    String? doctorName,
    String? doctorId,
    String? status,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      age: age ?? this.age,
      symptoms: symptoms ?? this.symptoms,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      contactNumber: contactNumber ?? this.contactNumber,
      doctorName: doctorName ?? this.doctorName,
      doctorId: doctorId ?? this.doctorId,
      status: status ?? this.status,
    );
  }
}
