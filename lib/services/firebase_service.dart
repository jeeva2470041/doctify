import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';
import '../models/user_model.dart';
import '../models/appointment_model.dart';
import 'firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  // Lazy getters to avoid initialization before Firebase.initializeApp()
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  /// Initialize Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// User Registration
  Future<UserCredential> registerUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'userType': 'patient',
        'createdAt': FieldValue.serverTimestamp(),
        'profileImageUrl': '',
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Doctor Registration
  Future<UserCredential> registerDoctor({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String specialization,
    required String experience,
    required String hospitalName,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create doctor document in Firestore
      await _firestore.collection('doctors').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'specialization': specialization,
        'experience': experience,
        'hospitalName': hospitalName,
        'isAvailable': true,
        'rating': 4.5,
        'profileImageUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// User Login
  Future<UserCredential> userLogin({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Doctor Login
  Future<UserCredential> doctorLogin({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Get all doctors
  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('doctors').get();
      return snapshot.docs
          .map((doc) => DoctorModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to fetch doctors: $e';
    }
  }

  /// Search doctors by specialization
  Future<List<DoctorModel>> searchDoctorsBySpecialization(String specialization) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('doctors')
          .where('specialization', isEqualTo: specialization)
          .get();
      return snapshot.docs
          .map((doc) => DoctorModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to search doctors: $e';
    }
  }

  /// Get doctor by ID
  Future<DoctorModel?> getDoctorById(String doctorId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('doctors').doc(doctorId).get();
      if (doc.exists) {
        return DoctorModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch doctor: $e';
    }
  }

  /// Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch user profile: $e';
    }
  }

  /// Book appointment
  Future<void> bookAppointment({
    required String doctorId,
    required String userId,
    required DateTime appointmentDate,
    required String timeSlot,
    required String reason,
  }) async {
    try {
      await _firestore.collection('appointments').add({
        'doctorId': doctorId,
        'userId': userId,
        'appointmentDate': appointmentDate,
        'timeSlot': timeSlot,
        'reason': reason,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to book appointment: $e';
    }
  }

  /// Get user appointments
  Future<List<AppointmentModel>> getUserAppointments(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('appointmentDate', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to fetch appointments: $e';
    }
  }

  /// Get doctor appointments
  Future<List<AppointmentModel>> getDoctorAppointments(String doctorId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .orderBy('appointmentDate', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to fetch appointments: $e';
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Handle Firebase Auth Exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
