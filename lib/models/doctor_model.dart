/// ============================================================
/// Doctor Model - Data class for Doctor Information
/// ============================================================
/// This model holds all the information about a doctor.
/// It is used across the app to display doctor details,
/// create new doctor profiles, and manage doctor data.
/// ============================================================

class DoctorModel {
  // Unique ID for each doctor
  final String id;

  // Doctor's full name
  final String name;

  // Doctor's email address
  final String email;

  // Doctor's password (for login) - Not stored in Firebase for security
  final String password;

  // Medical specialization (e.g., Cardiologist, Neurologist)
  final String specialization;

  // Years of experience
  final String experience;

  // Hospital where the doctor works
  final String hospitalName;

  // Contact phone number
  final String phoneNumber;

  // Whether the doctor is currently available
  final bool isAvailable;

  // URL for profile image (optional)
  final String profileImageUrl;

  // Doctor's rating/points (0-5 stars)
  final double rating;

  /// Constructor with named parameters
  /// Required fields are marked, optional ones have defaults
  DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.specialization,
    required this.experience,
    required this.hospitalName,
    required this.phoneNumber,
    this.isAvailable = true,
    this.profileImageUrl = '',
    this.rating = 4.5,
  });

  /// Creates a copy of this doctor with some fields updated.
  /// This is useful for editing doctor details without modifying the original.
  DoctorModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? specialization,
    String? experience,
    String? hospitalName,
    String? phoneNumber,
    bool? isAvailable,
    String? profileImageUrl,
    double? rating,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      hospitalName: hospitalName ?? this.hospitalName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAvailable: isAvailable ?? this.isAvailable,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
    );
  }

  /// Convert DoctorModel to a map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'specialization': specialization,
      'experience': experience,
      'hospitalName': hospitalName,
      'phoneNumber': phoneNumber,
      'isAvailable': isAvailable,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
    };
  }

  /// Create DoctorModel from a map (from Firebase)
  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: '', // Password is not retrieved from Firebase
      specialization: map['specialization'] ?? '',
      experience: map['experience'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      profileImageUrl: map['profileImageUrl'] ?? '',
      rating: (map['rating'] ?? 4.5).toDouble(),
    );
  }
}
