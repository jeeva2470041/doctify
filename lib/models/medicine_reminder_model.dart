class MedicineReminderModel {
  final String id;
  final String medicineName;
  final String dosage;
  final String time;
  final String frequency;
  final String status; // 'Pending', 'Taken', 'Missed'
  final String? notes;

  MedicineReminderModel({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.time,
    required this.frequency,
    required this.status,
    this.notes,
  });

  MedicineReminderModel copyWith({
    String? id,
    String? medicineName,
    String? dosage,
    String? time,
    String? frequency,
    String? status,
    String? notes,
  }) {
    return MedicineReminderModel(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      frequency: frequency ?? this.frequency,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'dosage': dosage,
      'time': time,
      'frequency': frequency,
      'status': status,
      'notes': notes,
    };
  }

  factory MedicineReminderModel.fromJson(Map<String, dynamic> json) {
    return MedicineReminderModel(
      id: json['id'] ?? '',
      medicineName: json['medicineName'] ?? '',
      dosage: json['dosage'] ?? '',
      time: json['time'] ?? '',
      frequency: json['frequency'] ?? '',
      status: json['status'] ?? 'Pending',
      notes: json['notes'],
    );
  }
}
