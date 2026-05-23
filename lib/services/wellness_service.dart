import 'dart:math';

class WellnessService {
  WellnessService._();
  static final WellnessService instance = WellnessService._();

  double heartRate = 72;
  int waterIntake = 1000;
  int waterGoal = 2500;
  double sleepHours = 7.0;

  List<Map<String, dynamic>> medicines = [
    {'name': 'Amoxicillin', 'dosage': '500mg', 'time': '8:00 AM', 'taken': true},
    {'name': 'Atorvastatin', 'dosage': '10mg', 'time': '9:00 PM', 'taken': false},
    {'name': 'Vitamin D3', 'dosage': '1000 IU', 'time': '12:00 PM', 'taken': false},
  ];

  int getHealthScore() {
    double score = 0;
    
    // Water score: up to 35 points
    double waterProgress = waterIntake / waterGoal;
    if (waterProgress > 1.0) waterProgress = 1.0;
    score += waterProgress * 35;

    // Sleep score: up to 35 points (ideal 8 hours)
    double sleepProgress = sleepHours / 8.0;
    if (sleepProgress > 1.0) sleepProgress = 1.0;
    score += sleepProgress * 35;

    // Medicine score: up to 30 points
    if (medicines.isNotEmpty) {
      int takenCount = medicines.where((m) => m['taken'] == true).length;
      score += (takenCount / medicines.length) * 30;
    } else {
      score += 30; 
    }

    return min(100, max(0, score.round()));
  }

  void addMedication(String name, String dosage, String time) {
    medicines.add({
      'name': name,
      'dosage': dosage,
      'time': time,
      'taken': false,
    });
  }

  String get heartRateLog => "${heartRate.round()} BPM";
  String get waterLog => "${waterIntake}ml / ${waterGoal}ml";
  String get sleepLog => "${sleepHours.toStringAsFixed(1)} Hrs";
  String get medsLog {
    if (medicines.isEmpty) return "No Medications";
    int takenCount = medicines.where((m) => m['taken'] == true).length;
    return "$takenCount/${medicines.length} Taken";
  }
}
