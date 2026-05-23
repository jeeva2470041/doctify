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

  // Doctor's specialization
  final String doctorSpecialization;

  // Consultation duration (e.g. "30 Mins")
  final String duration;

  // Current status of appointment
  // Possible values: 'Pending', 'Approved', 'Rejected'
  final String status;

  // Vitals sharing fields
  final bool attachVitals;
  final String? heartRateLog;
  final String? waterLog;
  final String? sleepLog;
  final String? medsLog;

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
    this.doctorSpecialization = 'General Physician',
    this.duration = '30 Mins',
    this.status = 'Pending',
    this.attachVitals = false,
    this.heartRateLog,
    this.waterLog,
    this.sleepLog,
    this.medsLog,
  });

  /// Creates a copy with updated fields
  AppointmentModel copyWith({
    String? id,
    String? patientName,
    int? age,
    String? symptoms,
    String? appointmentDate,
    String? contactNumber,
    String? doctorName,
    String? doctorId,
    String? doctorSpecialization,
    String? duration,
    String? status,
    bool? attachVitals,
    String? heartRateLog,
    String? waterLog,
    String? sleepLog,
    String? medsLog,
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
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      attachVitals: attachVitals ?? this.attachVitals,
      heartRateLog: heartRateLog ?? this.heartRateLog,
      waterLog: waterLog ?? this.waterLog,
      sleepLog: sleepLog ?? this.sleepLog,
      medsLog: medsLog ?? this.medsLog,
    );
  }

  /// Convert AppointmentModel to a map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'age': age,
      'symptoms': symptoms,
      'appointmentDate': appointmentDate,
      'contactNumber': contactNumber,
      'doctorName': doctorName,
      'doctorId': doctorId,
      'doctorSpecialization': doctorSpecialization,
      'duration': duration,
      'status': status,
      'attachVitals': attachVitals,
      'heartRateLog': heartRateLog,
      'waterLog': waterLog,
      'sleepLog': sleepLog,
      'medsLog': medsLog,
    };
  }

  /// Create AppointmentModel from a map (from Firebase)
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      patientName: map['patientName'] ?? '',
      age: map['age'] ?? 0,
      symptoms: map['symptoms'] ?? '',
      appointmentDate: map['appointmentDate'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      doctorName: map['doctorName'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorSpecialization: map['doctorSpecialization'] ?? 'General Physician',
      duration: map['duration'] ?? '30 Mins',
      status: map['status'] ?? 'Pending',
      attachVitals: map['attachVitals'] ?? false,
      heartRateLog: map['heartRateLog'],
      waterLog: map['waterLog'],
      sleepLog: map['sleepLog'],
      medsLog: map['medsLog'],
    );
  }
}
