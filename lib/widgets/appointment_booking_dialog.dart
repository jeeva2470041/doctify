/// ============================================================
/// Appointment Booking Dialog - User Booking Interface
/// ============================================================
/// Dialog for users to book appointments with doctors.
/// Collects patient info, appointment date/time, and duration.
/// Uses AppColors — adaptive to Light/Dark modes.
/// ============================================================

import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../models/appointment_model.dart';
import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../services/wellness_service.dart';

class AppointmentBookingDialog extends StatefulWidget {
  final DoctorModel doctor;
  final Function(AppointmentModel) onBookingConfirmed;
  final String? initialDuration;
  final String? initialSymptoms;

  const AppointmentBookingDialog({
    super.key,
    required this.doctor,
    required this.onBookingConfirmed,
    this.initialDuration,
    this.initialSymptoms,
  });

  @override
  State<AppointmentBookingDialog> createState() =>
      _AppointmentBookingDialogState();
}

class _AppointmentBookingDialogState extends State<AppointmentBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _contactController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedDuration = '30 Mins';
  String _selectedTimeSlot = '10:00 AM';
  bool _attachVitals = false;

  // Suffix lists for time categorization
  final List<String> _morningSlots = ['09:00 AM', '10:00 AM', '11:00 AM'];
  final List<String> _afternoonSlots = ['12:00 PM', '02:00 PM', '03:00 PM'];
  final List<String> _eveningSlots = ['04:00 PM', '05:00 PM', '06:00 PM'];

  // Taken slots for visual realism
  final Set<String> _unavailableSlots = {'11:00 AM', '05:00 PM'};

  @override
  void initState() {
    super.initState();
    if (widget.initialDuration != null) {
      _selectedDuration = widget.initialDuration!;
    }
    if (widget.initialSymptoms != null) {
      _symptomsController.text = widget.initialSymptoms!;
    }
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _ageController.dispose();
    _symptomsController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  // Format weekday number to short name
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  // Format month number to short name
  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }

  // Generate list of next 7 days
  List<DateTime> _getDatesList() {
    return List.generate(7, (index) {
      return DateTime.now().add(Duration(days: index));
    });
  }

  // Fallback system date picker for custom selections
  Future<void> _selectCustomDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.cardBg,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String get _formattedDateTimeString {
    final day = _selectedDate.day.toString().padLeft(2, '0');
    final month = _selectedDate.month.toString().padLeft(2, '0');
    final year = _selectedDate.year.toString();
    return '$day/$month/$year $_selectedTimeSlot';
  }

  void _submitBooking() {
    final formValid = _formKey.currentState!.validate();

    if (formValid) {
      final appointment = AppointmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientName: _patientNameController.text,
        age: int.parse(_ageController.text),
        symptoms: _symptomsController.text,
        appointmentDate: _formattedDateTimeString,
        contactNumber: _contactController.text,
        doctorName: widget.doctor.name,
        doctorId: widget.doctor.id,
        doctorSpecialization: widget.doctor.specialization,
        duration: _selectedDuration,
        status: 'Pending',
        attachVitals: _attachVitals,
        heartRateLog: _attachVitals ? WellnessService.instance.heartRateLog : null,
        waterLog: _attachVitals ? WellnessService.instance.waterLog : null,
        sleepLog: _attachVitals ? WellnessService.instance.sleepLog : null,
        medsLog: _attachVitals ? WellnessService.instance.medsLog : null,
      );

      dummyAppointments.add(appointment);
      widget.onBookingConfirmed(appointment);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Appointment Request Sent Successfully'),
          backgroundColor: AppColors.available,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: AppColors.cardBg,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 480,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- Dialog Header ----
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Book Appointment',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'with ${widget.doctor.name} (${widget.doctor.specialization})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.20),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---- Form Content ----
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient Info Fields
                      _buildField(
                        controller: _patientNameController,
                        label: 'Patient Name',
                        hint: 'Enter your full name',
                        icon: Icons.person,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildField(
                              controller: _ageController,
                              label: 'Age',
                              hint: 'Age',
                              icon: Icons.cake,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required';
                                if (int.tryParse(v) == null) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: _buildField(
                              controller: _contactController,
                              label: 'Contact Number',
                              hint: 'Phone number',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _symptomsController,
                        label: 'Symptoms / Symptoms Description',
                        hint: 'Describe your symptoms...',
                        icon: Icons.medical_services_outlined,
                        maxLines: 2,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please describe symptoms'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      
                      // ---- Novelty Feature: Vitals Sharing Toggle Card ----
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _attachVitals ? AppColors.primary : AppColors.border,
                            width: _attachVitals ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.monitor_heart_rounded,
                                  color: _attachVitals ? AppColors.primary : AppColors.textSecondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Attach Wellness Vitals',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Share heart rate, water, sleep & pill logs',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch.adaptive(
                                  value: _attachVitals,
                                  activeColor: AppColors.primary,
                                  onChanged: (val) {
                                    setState(() {
                                      _attachVitals = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (_attachVitals) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(height: 1, thickness: 1),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildVitalBadge(Icons.favorite, AppColors.busy, WellnessService.instance.heartRateLog),
                                  _buildVitalBadge(Icons.water_drop, Colors.blue, WellnessService.instance.waterLog),
                                  _buildVitalBadge(Icons.bedtime, Colors.indigo, WellnessService.instance.sleepLog),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      Divider(color: AppColors.divider, height: 1),
                      const SizedBox(height: 16),

                      // ---- Novelty Feature: Consultation Duration Selector ----
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Consultation Duration',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['15 Mins', '30 Mins', '45 Mins', '60 Mins'].map((duration) {
                          final isSelected = _selectedDuration == duration;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: InkWell(
                                onTap: () => setState(() => _selectedDuration = duration),
                                borderRadius: BorderRadius.circular(10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.12)
                                        : AppColors.background,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.border,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      duration,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // ---- Novelty Feature: Horizontal Date Strip Selector ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                'Select Date',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _selectCustomDate(context),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'More Dates',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ..._getDatesList().map((date) {
                              final isSelected = date.day == _selectedDate.day &&
                                  date.month == _selectedDate.month &&
                                  date.year == _selectedDate.year;
                              final dayName = _getDayName(date.weekday);
                              final monthName = _getMonthName(date.month);
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: InkWell(
                                  onTap: () => setState(() => _selectedDate = date),
                                  borderRadius: BorderRadius.circular(12),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: isSelected ? AppColors.primaryGradient : null,
                                      color: isSelected ? null : AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? Colors.transparent : AppColors.border,
                                        width: 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary.withOpacity(0.25),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          dayName,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${date.day}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? Colors.white : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          monthName,
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? Colors.white70 : AppColors.textHint,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---- Novelty Feature: Categorized Time Slots ----
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Select Time Slot',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Morning Slots
                      _buildTimeCategorySection('Morning', _morningSlots),
                      const SizedBox(height: 8),

                      // Afternoon Slots
                      _buildTimeCategorySection('Afternoon', _afternoonSlots),
                      const SizedBox(height: 8),

                      // Evening Slots
                      _buildTimeCategorySection('Evening', _eveningSlots),

                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: AppColors.primary, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.28),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _submitBooking,
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle, size: 16, color: Colors.white),
                                        SizedBox(width: 6),
                                        Text(
                                          'Confirm',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCategorySection(String title, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            final isTaken = _unavailableSlots.contains(slot);
            
            return InkWell(
              onTap: isTaken ? null : () => setState(() => _selectedTimeSlot = slot),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isTaken ? AppColors.background.withOpacity(0.5) : AppColors.background),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isTaken ? AppColors.border.withOpacity(0.5) : AppColors.border),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isTaken) ...[
                      Icon(
                        Icons.block_flipped,
                        size: 11,
                        color: AppColors.textHint.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      slot,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : (isTaken ? AppColors.textHint.withOpacity(0.7) : AppColors.textPrimary),
                        decoration: isTaken ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: AppColors.textHint,
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.busy, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      ),
    );
  }

  Widget _buildVitalBadge(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
