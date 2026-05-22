/// ============================================================
/// DEPRECATED - Dummy Data (No longer used)
/// ============================================================
/// This file is DEPRECATED and should not be used anymore.
/// All data should now come from Firebase.
/// 
/// Please use the FirebaseService class instead:
/// - lib/services/firebase_service.dart
/// 
/// For setup instructions, see:
/// - FIREBASE_SETUP.md
/// ============================================================
/// 
/// To migrate:
/// 1. Remove imports of dummy_data.dart from your screens
/// 2. Import FirebaseService instead
/// 3. Use FirebaseService methods to fetch data from Firestore
/// 
/// Example:
/// Instead of: List<DoctorModel> doctors = dummyDoctors;
/// Use:
///   final firebaseService = FirebaseService();
///   List<DoctorModel> doctors = await firebaseService.getAllDoctors();
/// ============================================================

import '../models/doctor_model.dart';
import '../models/user_model.dart';
import '../models/appointment_model.dart';
import '../models/notification_model.dart';

List<DoctorModel> dummyDoctors = [
  DoctorModel(
    id: '1',
    name: 'Dr. Priya Sharma',
    email: 'priya@doctor.com',
    password: '123456',
    specialization: 'Cardiologist',
    experience: '12 Years',
    hospitalName: 'Apollo Hospital',
    phoneNumber: '+91 98765 43210',
    isAvailable: true,
    profileImageUrl: '',
    rating: 4.8,
  ),
  DoctorModel(
    id: '2',
    name: 'Dr. Arjun Mehta',
    email: 'arjun@doctor.com',
    password: '123456',
    specialization: 'Neurologist',
    experience: '8 Years',
    hospitalName: 'Fortis Hospital',
    phoneNumber: '+91 98765 43211',
    isAvailable: true,
    profileImageUrl: '',
    rating: 4.6,
  ),
  DoctorModel(
    id: '3',
    name: 'Dr. Sneha Patel',
    email: 'sneha@doctor.com',
    password: '123456',
    specialization: 'Dermatologist',
    experience: '5 Years',
    hospitalName: 'Max Healthcare',
    phoneNumber: '+91 98765 43212',
    isAvailable: false,
    profileImageUrl: '',
    rating: 4.5,
  ),
  DoctorModel(
    id: '4',
    name: 'Dr. Rahul Verma',
    email: 'rahul@doctor.com',
    password: '123456',
    specialization: 'Orthopedic Surgeon',
    experience: '15 Years',
    hospitalName: 'AIIMS Delhi',
    phoneNumber: '+91 98765 43213',
    isAvailable: true,
    profileImageUrl: '',
    rating: 4.9,
  ),
  DoctorModel(
    id: '5',
    name: 'Dr. Ananya Gupta',
    email: 'ananya@doctor.com',
    password: '123456',
    specialization: 'Pediatrician',
    experience: '10 Years',
    hospitalName: 'Medanta Hospital',
    phoneNumber: '+91 98765 43214',
    isAvailable: true,
    profileImageUrl: '',
    rating: 4.7,
  ),
  DoctorModel(
    id: '6',
    name: 'Dr. Vikram Singh',
    email: 'vikram@doctor.com',
    password: '123456',
    specialization: 'General Physician',
    experience: '7 Years',
    hospitalName: 'City Care Hospital',
    phoneNumber: '+91 98765 43215',
    isAvailable: false,
    profileImageUrl: '',
    rating: 4.4,
  ),
];

List<UserModel> registeredUsers = [
  UserModel(
    id: '1',
    name: 'Test User',
    email: 'user@test.com',
    password: '123456',
    favoriteDoctorIds: [],
  ),
];

List<AppointmentModel> dummyAppointments = [
  AppointmentModel(
    id: '1',
    patientName: 'Rajesh Kumar',
    age: 45,
    symptoms: 'Chest pain and shortness of breath',
    appointmentDate: '2026-05-25 10:30 AM',
    contactNumber: '+91 98765 11111',
    doctorName: 'Dr. Priya Sharma',
    doctorId: '1',
    doctorSpecialization: 'Cardiologist',
    duration: '30 Mins',
    status: 'Pending',
  ),
  AppointmentModel(
    id: '2',
    patientName: 'Priya Singh',
    age: 32,
    symptoms: 'Severe headaches and dizziness',
    appointmentDate: '2026-05-26 02:00 PM',
    contactNumber: '+91 98765 22222',
    doctorName: 'Dr. Arjun Mehta',
    doctorId: '2',
    doctorSpecialization: 'Neurologist',
    duration: '45 Mins',
    status: 'Approved',
  ),
  AppointmentModel(
    id: '3',
    patientName: 'Amit Patel',
    age: 28,
    symptoms: 'Skin irritation and rashes',
    appointmentDate: '2026-05-27 11:00 AM',
    contactNumber: '+91 98765 33333',
    doctorName: 'Dr. Sneha Patel',
    doctorId: '3',
    doctorSpecialization: 'Dermatologist',
    duration: '15 Mins',
    status: 'Pending',
  ),
  AppointmentModel(
    id: '4',
    patientName: 'Neha Gupta',
    age: 38,
    symptoms: 'Joint pain in knee and back',
    appointmentDate: '2026-05-28 03:30 PM',
    contactNumber: '+91 98765 44444',
    doctorName: 'Dr. Rahul Verma',
    doctorId: '4',
    doctorSpecialization: 'Orthopedic Surgeon',
    duration: '30 Mins',
    status: 'Rejected',
  ),
];

List<NotificationModel> userNotifications = [
  NotificationModel(
    id: '1',
    title: 'Appointment Approved',
    message: 'Dr. Priya approved your booking for cardiology consultation',
    icon: '✓',
    timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    isRead: false,
  ),
  NotificationModel(
    id: '2',
    title: 'Appointment Rejected',
    message: 'Dr. Vikram has unavailable slots. Please choose another time.',
    icon: '✗',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    isRead: false,
  ),
  NotificationModel(
    id: '3',
    title: 'Booking Successful',
    message: 'Your appointment with Dr. Arjun Mehta has been booked',
    icon: '✓',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: true,
  ),
  NotificationModel(
    id: '4',
    title: 'Doctor Available',
    message: 'Dr. Sneha Patel is now available for consultations',
    icon: '●',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    isRead: true,
  ),
];

