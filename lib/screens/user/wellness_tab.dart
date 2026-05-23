import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/wellness_service.dart';

class WellnessTab extends StatefulWidget {
  const WellnessTab({super.key});

  @override
  State<WellnessTab> createState() => _WellnessTabState();
}

class _WellnessTabState extends State<WellnessTab> with SingleTickerProviderStateMixin {
  final _wellness = WellnessService.instance;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    // Wave animation for the heart rate ECG line
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showAddMedicationDialog() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    String selectedTime = "8:00 AM";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Icon(Icons.medication, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Add Medication',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Medication Name',
                        labelStyle: TextStyle(color: AppColors.textHint),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dosageController,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Dosage (e.g. 1 pill, 500mg)',
                        labelStyle: TextStyle(color: AppColors.textHint),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reminder Time:',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        DropdownButton<String>(
                          value: selectedTime,
                          dropdownColor: AppColors.cardBg,
                          style: TextStyle(color: AppColors.textPrimary),
                          items: <String>[
                            '8:00 AM',
                            '9:00 AM',
                            '12:00 PM',
                            '2:00 PM',
                            '6:00 PM',
                            '9:00 PM',
                            '10:00 PM'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                selectedTime = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && dosageController.text.isNotEmpty) {
                      _wellness.addMedication(
                        nameController.text,
                        dosageController.text,
                        selectedTime,
                      );
                      Navigator.pop(context);
                      _refresh();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final healthScore = _wellness.getHealthScore();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Interactive Wellness Hub',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Top Health Score Header Card ----
            _buildHealthScoreHeaderCard(healthScore),
            const SizedBox(height: 20),

            // ---- Grid for Vitals logs ----
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heart Rate Column
                Expanded(
                  child: Column(
                    children: [
                      _buildHeartRateCard(),
                      const SizedBox(height: 16),
                      _buildSleepTrackerCard(),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Water Tracker Column
                Expanded(
                  child: _buildWaterTrackerCard(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ---- Today's Medications checklist ----
            _buildMedicationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthScoreHeaderCard(int score) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Score Circle Animation
          HealthScoreCircle(score: score),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Progress',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  score >= 80
                      ? 'Excellent health stats!'
                      : score >= 50
                          ? 'On the right track!'
                          : 'Needs logging & attention!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Log your sleep, complete medications, and drink water to reach a score of 100%.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Heart Rate',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const Icon(
                Icons.favorite,
                color: AppColors.busy,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _wellness.heartRate.round().toString(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'BPM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Wave graph
          SizedBox(
            height: 48,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: HeartRateWavePainter(
                    _waveController.value,
                    AppColors.busy,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Heart rate toggle button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tap to measure:',
                style: TextStyle(fontSize: 10, color: AppColors.textHint),
              ),
              GestureDetector(
                onTap: () {
                  // Simulate minor heart rate reading changes
                  setState(() {
                    _wellness.heartRate = 65.0 + Random().nextInt(20);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.autorenew_rounded, size: 10, color: AppColors.primary),
                      const SizedBox(width: 4),
                      const Text(
                        'Measure',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterTrackerCard() {
    final progress = _wellness.waterIntake / _wellness.waterGoal;
    final fillPercent = progress > 1.0 ? 1.0 : progress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Water Intake',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const Icon(
                Icons.water_drop,
                color: Colors.blue,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${(_wellness.waterIntake / 1000).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'L',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          Text(
            'Goal: ${(_wellness.waterGoal / 1000).toStringAsFixed(1)}L',
            style: TextStyle(fontSize: 10.5, color: AppColors.textHint),
          ),
          const SizedBox(height: 16),
          // Interactive Water Glass container
          Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Glass frame
                Container(
                  width: 66,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    border: Border.all(
                      color: AppColors.border,
                      width: 3.5,
                    ),
                  ),
                ),
                // Animated Water Filling Level
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: 59,
                  height: 113 * fillPercent,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.65),
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                      topLeft: Radius.circular(fillPercent > 0.95 ? 4 : 0),
                      topRight: Radius.circular(fillPercent > 0.95 ? 4 : 0),
                    ),
                  ),
                ),
                // Bubble Overlay
                if (fillPercent > 0.1)
                  Positioned(
                    bottom: 20,
                    child: Icon(
                      Icons.bubble_chart_rounded,
                      size: 24,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Incrementor buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_wellness.waterIntake >= 250) {
                      _wellness.waterIntake -= 250;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.remove, size: 14, color: AppColors.textPrimary),
                ),
              ),
              Text(
                '+250ml',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _wellness.waterIntake += 250;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 14, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTrackerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sleep hours',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const Icon(
                Icons.bedtime,
                color: Colors.indigo,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _wellness.sleepHours.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Hours',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Slide selector
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3.5,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.12),
            ),
            child: Slider(
              value: _wellness.sleepHours,
              min: 3.0,
              max: 12.0,
              divisions: 18,
              label: '${_wellness.sleepHours.toStringAsFixed(1)}h',
              onChanged: (value) {
                setState(() {
                  _wellness.sleepHours = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '3.0 hrs',
                style: TextStyle(fontSize: 9.5, color: AppColors.textHint),
              ),
              Text(
                'Ideal: 7-9 hrs',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: _wellness.sleepHours >= 7 && _wellness.sleepHours <= 9
                      ? AppColors.available
                      : AppColors.pending,
                ),
              ),
              Text(
                '12.0 hrs',
                style: TextStyle(fontSize: 9.5, color: AppColors.textHint),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pill Schedule',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Mark medicines taken today',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showAddMedicationDialog,
                icon: const Icon(Icons.add, size: 12, color: Colors.white),
                label: const Text(
                  'Add Pill',
                  style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_wellness.medicines.isEmpty)
             Padding(
               padding: const EdgeInsets.symmetric(vertical: 20),
               child: Center(
                 child: Text(
                   'No pills added for today.',
                   style: TextStyle(color: AppColors.textHint, fontSize: 13),
                 ),
               ),
             )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _wellness.medicines.length,
              itemBuilder: (context, index) {
                final med = _wellness.medicines[index];
                final isTaken = med['taken'] == true;

                return Card(
                  color: AppColors.background,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.border, width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isTaken ? AppColors.availableBg : AppColors.primaryBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.medication,
                        color: isTaken ? AppColors.available : AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      med['name'],
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        decoration: isTaken ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      '${med['dosage']} • ${med['time']}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: Checkbox(
                      value: isTaken,
                      activeColor: AppColors.available,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (bool? value) {
                        setState(() {
                          med['taken'] = value ?? false;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ---- Custom Painter for Heart Rate wave (ECG style) ----
class HeartRateWavePainter extends CustomPainter {
  final double animationValue;
  final Color waveColor;

  HeartRateWavePainter(this.animationValue, this.waveColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    double width = size.width;
    double height = size.height;
    double midY = height / 2;

    path.moveTo(0, midY);

    for (double x = 0; x <= width; x++) {
      double relativeProgress = x / width;
      // Shift wave phase dynamically by animationValue
      double phase = (relativeProgress + animationValue) % 1.0;

      double y = midY;

      // Draw two ECG-like pulses across screen width
      if (phase >= 0.2 && phase < 0.3) {
        // T-wave spike inside the interval
        double t = (phase - 0.2) / 0.1;
        if (t < 0.2) {
          y = midY - (t / 0.2) * (height * 0.4); 
        } else if (t < 0.6) {
          y = midY + ((t - 0.2) / 0.4) * (height * 0.8) - (height * 0.4);
        } else {
          y = midY - ((t - 0.6) / 0.4) * (height * 0.4);
        }
      } else {
        // Small fluctuation baseline
        y = midY + sin((relativeProgress + animationValue) * 2 * pi * 8) * 1.5;
      }

      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HeartRateWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// ---- Health Score Circle Animation Widget ----
class HealthScoreCircle extends StatefulWidget {
  final int score;
  const HealthScoreCircle({super.key, required this.score});

  @override
  State<HealthScoreCircle> createState() => _HealthScoreCircleState();
}

class _HealthScoreCircleState extends State<HealthScoreCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.0, end: widget.score / 100.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant HealthScoreCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.score / 100.0,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentPercentValue = (_animation.value * 100).round();
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$currentPercentValue%',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'HEALTH',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
