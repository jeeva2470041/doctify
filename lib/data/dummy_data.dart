/// ============================================================
/// Dummy Data - Pre-loaded Doctor Information
/// ============================================================
/// This file contains sample doctor data for testing the app.
/// In a real app, this data would come from a database or API.
/// We use local lists to keep things beginner-friendly.
/// ============================================================

import '../models/doctor_model.dart';
import '../models/user_model.dart';

/// List of dummy doctors - this acts as our local "database"
/// New doctors registered through the app will be added here
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
  ),
];

/// List of registered users - new users will be added here
List<UserModel> registeredUsers = [
  UserModel(
    id: '1',
    name: 'Test User',
    email: 'user@test.com',
    password: '123456',
  ),
];
