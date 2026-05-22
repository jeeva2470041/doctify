# Firebase Setup Guide for Doctor Info App

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a new project"
3. Enter project name (e.g., "doctor-info-app")
4. Enable/disable Google Analytics (optional)
5. Create the project

## Step 2: Add Your App to Firebase

### For Android:
1. Go to Project Settings > Your Apps
2. Click "Add app" and select Android
3. Enter your package name (check in `android/app/build.gradle`)
4. Download `google-services.json`
5. Place it in `android/app/`
6. Add the following to `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```
7. Add to `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### For iOS:
1. Go to Project Settings > Your Apps
2. Click "Add app" and select iOS
3. Enter your bundle ID (check in `ios/Runner.xcodeproj`)
4. Download `GoogleService-Info.plist`
5. Open `ios/Runner.xcworkspace` in Xcode
6. Drag `GoogleService-Info.plist` into the project
7. Make sure it's added to all targets

### For Web:
1. Go to Project Settings > Your Apps
2. Click "Add app" and select Web
3. Copy the Firebase config

## Step 3: Update Firebase Configuration

1. Open `lib/services/firebase_options.dart`
2. Replace the placeholder values with your Firebase project credentials
3. Get credentials from Firebase Console:
   - Go to Project Settings > Your apps
   - Copy the relevant configuration for each platform

## Step 4: Set Up Firestore Database

1. Go to Firestore Database in Firebase Console
2. Click "Create database"
3. Select "Start in test mode" (for development)
4. Choose a region close to your users
5. Create the following collections:

### Collections Structure:

**users** collection:
```
{
  id: string (user ID)
  name: string
  email: string
  phoneNumber: string
  userType: string ("patient")
  createdAt: timestamp
  profileImageUrl: string
}
```

**doctors** collection:
```
{
  id: string (doctor ID)
  name: string
  email: string
  phoneNumber: string
  specialization: string
  experience: string
  hospitalName: string
  isAvailable: boolean
  rating: number
  profileImageUrl: string
  createdAt: timestamp
}
```

**appointments** collection:
```
{
  doctorId: string
  userId: string
  appointmentDate: timestamp
  timeSlot: string
  reason: string
  status: string ("pending", "approved", "rejected")
  createdAt: timestamp
}
```

## Step 5: Update Security Rules

In Firestore Console, go to Rules and update:

```rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth.uid != null;
      allow create: if request.auth.uid == userId;
      allow update, delete: if request.auth.uid == userId;
    }
    
    // Doctors collection
    match /doctors/{doctorId} {
      allow read: if request.auth.uid != null;
      allow create: if request.auth.uid == doctorId;
      allow update, delete: if request.auth.uid == doctorId;
    }
    
    // Appointments collection
    match /appointments/{appointmentId} {
      allow read: if request.auth.uid != null && 
        (resource.data.userId == request.auth.uid || 
         resource.data.doctorId == request.auth.uid);
      allow create: if request.auth.uid != null;
      allow update: if request.auth.uid != null && 
        (resource.data.userId == request.auth.uid || 
         resource.data.doctorId == request.auth.uid);
    }
  }
}
```

## Step 6: Enable Authentication

1. Go to Authentication in Firebase Console
2. Click "Get Started"
3. Enable "Email/Password" provider
4. Save

## Step 7: Install Dependencies

Run:
```bash
flutter pub get
```

This will install all Firebase packages listed in `pubspec.yaml`.

## Step 8: Initialize Firebase in Your App

Firebase is already initialized in `main.dart`. Just ensure it's called before running the app.

## Usage Example

The `FirebaseService` singleton class handles all Firebase operations:

```dart
// Get the service instance
final firebaseService = FirebaseService();

// Register a user
await firebaseService.registerUser(
  email: 'user@example.com',
  password: 'password123',
  name: 'John Doe',
  phoneNumber: '+1234567890',
);

// Login
await firebaseService.userLogin(
  email: 'user@example.com',
  password: 'password123',
);

// Get all doctors
final doctors = await firebaseService.getAllDoctors();

// Search doctors
final specialists = await firebaseService.searchDoctorsBySpecialization('Cardiologist');

// Book appointment
await firebaseService.bookAppointment(
  doctorId: 'doctor_id',
  userId: 'user_id',
  appointmentDate: DateTime.now().add(Duration(days: 1)),
  timeSlot: '10:00 AM',
  reason: 'Regular checkup',
);

// Logout
await firebaseService.logout();
```

## Troubleshooting

1. **Authentication errors**: Ensure email/password provider is enabled
2. **Firestore errors**: Check security rules are correctly configured
3. **Connection issues**: Verify Firebase project ID is correct in firebase_options.dart
4. **Android issues**: Ensure google-services.json is in the right location
5. **iOS issues**: Ensure GoogleService-Info.plist is added to all targets in Xcode
