# Migration Guide: Dummy Data → Firebase

## Overview
This guide helps you migrate your screens from using dummy data to Firebase.

## Files That Need Updates

The following files currently import and use `dummy_data.dart`:

1. **User Screens:**
   - `lib/screens/login/user_login_screen.dart`
   - `lib/screens/register/user_register_screen.dart`
   - `lib/screens/user/user_home_screen.dart`
   - `lib/screens/user/home_tab.dart`
   - `lib/screens/user/profile_tab.dart`
   - `lib/screens/user/my_bookings_tab.dart`

2. **Doctor Screens:**
   - `lib/screens/login/doctor_login_screen.dart`
   - `lib/screens/register/doctor_register_screen.dart`

3. **Widgets:**
   - `lib/widgets/appointment_booking_dialog.dart`
   - `lib/widgets/notifications_bottom_sheet.dart`

## Step-by-Step Migration

### Step 1: Replace Import Statements

**Old:**
```dart
import '../../data/dummy_data.dart';
```

**New:**
```dart
import '../../services/firebase_service.dart';
```

### Step 2: Replace Data Access Code

#### Example 1: Getting all doctors

**Old:**
```dart
List<DoctorModel> doctors = dummyDoctors;
```

**New:**
```dart
final firebaseService = FirebaseService();
List<DoctorModel> doctors = await firebaseService.getAllDoctors();
```

#### Example 2: User Registration

**Old:**
```dart
final exists = registeredUsers.any((u) => u.email == email);
if (!exists) {
  registeredUsers.add(newUser);
}
```

**New:**
```dart
try {
  await firebaseService.registerUser(
    email: email,
    password: password,
    name: name,
    phoneNumber: phoneNumber,
  );
  // Show success message
} catch (e) {
  // Show error message
}
```

#### Example 3: User Login

**Old:**
```dart
final user = registeredUsers.where(
  (u) => u.email == _emailController.text && u.password == _passwordController.text
);
```

**New:**
```dart
try {
  final userCredential = await firebaseService.userLogin(
    email: _emailController.text,
    password: _passwordController.text,
  );
  // User is logged in
} on FirebaseAuthException catch (e) {
  // Show error
}
```

#### Example 4: Doctor Registration

**Old:**
```dart
final exists = dummyDoctors.any((d) => d.email == email);
if (!exists) {
  dummyDoctors.add(newDoctor);
}
```

**New:**
```dart
try {
  await firebaseService.registerDoctor(
    email: email,
    password: password,
    name: name,
    phoneNumber: phoneNumber,
    specialization: specialization,
    experience: experience,
    hospitalName: hospitalName,
  );
  // Show success message
} catch (e) {
  // Show error message
}
```

#### Example 5: Search Doctors by Specialization

**Old:**
```dart
List<DoctorModel> filtered = List.from(dummyDoctors);
if (searchTerm.isNotEmpty) {
  filtered = filtered.where((d) =>
    d.specialization.toLowerCase().contains(searchTerm.toLowerCase())
  ).toList();
}
```

**New:**
```dart
final firebaseService = FirebaseService();
List<DoctorModel> filtered = await firebaseService.searchDoctorsBySpecialization(searchTerm);
```

#### Example 6: Book Appointment

**Old:**
```dart
AppointmentModel newAppointment = AppointmentModel(
  id: DateTime.now().toString(),
  // ... other fields
);
dummyAppointments.add(newAppointment);
```

**New:**
```dart
await firebaseService.bookAppointment(
  doctorId: doctorId,
  userId: firebaseService.currentUserId!,
  appointmentDate: selectedDate,
  timeSlot: selectedTimeSlot,
  reason: reason,
);
```

#### Example 7: Get User Appointments

**Old:**
```dart
List<AppointmentModel> userAppointments = appointmentBookings
  .where((a) => a.userId == currentUserId)
  .toList();
```

**New:**
```dart
List<AppointmentModel> userAppointments = await firebaseService.getUserAppointments(
  firebaseService.currentUserId!
);
```

## Handle Async Operations

Firebase operations are **asynchronous** (return `Future`), so you need to update your widgets:

### Using FutureBuilder

```dart
FutureBuilder<List<DoctorModel>>(
  future: FirebaseService().getAllDoctors(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    
    final doctors = snapshot.data ?? [];
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return DoctorCard(doctor: doctors[index]);
      },
    );
  },
)
```

### Using StreamBuilder (Real-time Updates)

```dart
// For real-time appointment updates, you can use Firestore listeners
FirebaseFirestore.instance
  .collection('appointments')
  .where('userId', isEqualTo: userId)
  .snapshots()
  .listen((snapshot) {
    final appointments = snapshot.docs
      .map((doc) => AppointmentModel.fromMap(doc.data()))
      .toList();
    // Update UI with appointments
  });
```

## Error Handling

Always handle Firebase errors gracefully:

```dart
try {
  final doctors = await FirebaseService().getAllDoctors();
} catch (e) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

## Testing During Migration

1. **Set up Firebase locally:**
   - Use Firebase emulator for development
   - Or use a test Firebase project

2. **Test each screen one by one**

3. **Verify:**
   - Registration works
   - Login works
   - Data displays correctly
   - Appointments can be booked
   - Search functionality works

## Debugging Tips

1. **Check Firebase Connection:**
   ```dart
   print('Current user: ${FirebaseService().currentUser}');
   ```

2. **Print Firestore Data:**
   ```dart
   final doctors = await FirebaseService().getAllDoctors();
   print('Doctors: ${doctors.length}');
   ```

3. **Check Console Logs:**
   - Android: `flutter logs`
   - iOS: Xcode console
   - Web: Browser console

4. **Use Firebase Console:**
   - Check if data is being stored correctly
   - Verify security rules aren't blocking access
   - Monitor database usage

## Common Issues

### Issue: No data appears
- **Check:** Firebase security rules
- **Check:** Data is properly saved to Firestore
- **Check:** User is logged in

### Issue: Authentication fails
- **Check:** Email/Password provider is enabled
- **Check:** Correct email/password format
- **Check:** User exists in Firebase

### Issue: App crashes on initialization
- **Check:** Firebase configuration in `firebase_options.dart`
- **Check:** `firebase_core` package is properly initialized
- **Check:** Google Services file is in correct location

## Next Steps

1. Update each screen gradually
2. Test thoroughly
3. Remove `dummy_data.dart` import from all files
4. Delete `dummy_data.dart` when no longer needed
5. Deploy to production

## Support

For Firebase documentation, see:
- [Firebase Docs](https://firebase.google.com/docs)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Firebase Auth](https://firebase.google.com/docs/auth)
