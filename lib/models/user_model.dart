/// ============================================================
/// User Model - Data class for Normal User Information
/// ============================================================
/// This model holds the information about a normal user.
/// Users can browse doctor listings and view doctor profiles.
/// ============================================================

class UserModel {
  // Unique ID for each user
  final String id;

  // User's full name
  final String name;

  // User's email address
  final String email;

  // User's password (for login) - Not stored in Firebase for security
  final String password;

  // User's phone number
  final String phoneNumber;

  // List of favorite doctor IDs
  final List<String> favoriteDoctorIds;

  /// Constructor with named parameters
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phoneNumber = '',
    this.favoriteDoctorIds = const [],
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    List<String>? favoriteDoctorIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      favoriteDoctorIds: favoriteDoctorIds ?? this.favoriteDoctorIds,
    );
  }

  /// Convert UserModel to a map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'favoriteDoctorIds': favoriteDoctorIds,
    };
  }

  /// Create UserModel from a map (from Firebase)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: '', // Password is not retrieved from Firebase
      phoneNumber: map['phoneNumber'] ?? '',
      favoriteDoctorIds: List<String>.from(map['favoriteDoctorIds'] ?? []),
    );
  }
}
