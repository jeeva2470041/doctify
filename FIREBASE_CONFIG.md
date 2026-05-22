# Firebase Configuration Summary

## Project Details
- **Project ID:** `campus-share-6accf`
- **Project Number:** `66815410352`
- **Storage Bucket:** `campus-share-6accf.firebasestorage.app`
- **Auth Domain:** `campus-share-6accf.firebaseapp.com`

## Android Configuration
- **Package Name:** `com.example.doctorapps`
- **Mobile SDK App ID:** `1:66815410352:android:40afd91897b1a0cb52fb75`
- **API Key:** `AIzaSyDG6HywB1d98nyN5HbO3pqVVC36_vh8LJI`

## Files Updated

### 1. ✅ `lib/services/firebase_options.dart`
- Updated with correct project credentials
- Android platform set as default

### 2. ✅ `android/app/google-services.json`
- Copied from your downloaded file

### 3. ✅ `android/app/build.gradle.kts`
- Updated package name: `com.example.doctorapps`
- Added Google Services plugin: `id("com.google.gms.google-services")`

### 4. ✅ `android/build.gradle.kts`
- Added Google Services plugin dependency: `com.google.gms.google-services` version `4.4.0`

### 5. ✅ `pubspec.yaml`
- Added Firebase dependencies (already done)

## Next Steps

1. **Run Flutter pub get:**
   ```bash
   flutter pub get
   ```

2. **Build and run on Android:**
   ```bash
   flutter run
   ```

3. **Firebase Console Setup:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select project: `campus-share-6accf`
   - Set up Firestore Database
   - Enable Authentication (Email/Password)
   - Configure Security Rules

4. **Test Firebase Connection:**
   ```bash
   flutter logs
   ```

## Firebase Collections to Create in Firestore

### 1. `users` Collection
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "phoneNumber": "string",
  "userType": "patient",
  "createdAt": "timestamp",
  "profileImageUrl": "string"
}
```

### 2. `doctors` Collection
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "phoneNumber": "string",
  "specialization": "string",
  "experience": "string",
  "hospitalName": "string",
  "isAvailable": "boolean",
  "rating": "number",
  "profileImageUrl": "string",
  "createdAt": "timestamp"
}
```

### 3. `appointments` Collection
```json
{
  "doctorId": "string",
  "userId": "string",
  "appointmentDate": "timestamp",
  "timeSlot": "string",
  "reason": "string",
  "status": "pending|approved|rejected",
  "createdAt": "timestamp"
}
```

## Verification Checklist

- [ ] google-services.json is in `android/app/`
- [ ] Package name matches in build.gradle.kts
- [ ] Google Services plugin added to build.gradle files
- [ ] Firebase dependencies in pubspec.yaml
- [ ] firebase_options.dart has correct credentials
- [ ] Firebase authentication enabled in Console
- [ ] Firestore collections created
- [ ] Security rules configured
- [ ] App builds successfully
- [ ] Firebase connection works

## Troubleshooting

If you encounter errors:

1. **Gradle build failure:**
   ```bash
   flutter clean
   cd android
   ./gradlew clean
   cd ..
   flutter pub get
   ```

2. **Firebase connection errors:**
   - Check package name matches
   - Verify google-services.json is present
   - Check Firebase credentials in firebase_options.dart

3. **Authentication issues:**
   - Enable Email/Password provider in Firebase Console
   - Check Firestore Security Rules
   - Verify user exists in Firebase Auth

For more details, see:
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)
