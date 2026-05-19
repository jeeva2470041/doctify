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

  // User's password (for login)
  final String password;

  /// Constructor with named parameters
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });
}
