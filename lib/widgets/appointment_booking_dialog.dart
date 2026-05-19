/// ============================================================
/// Appointment Booking Dialog - User Booking Interface
/// ============================================================
/// Dialog for users to book appointments with doctors.
/// Collects patient info and appointment details.
/// ============================================================

import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../models/appointment_model.dart';
import '../data/dummy_data.dart';

class AppointmentBookingDialog extends StatefulWidget {
  // The doctor being booked
  final DoctorModel doctor;

  // Callback when booking is confirmed
  final Function(AppointmentModel) onBookingConfirmed;

  const AppointmentBookingDialog({
    super.key,
    required this.doctor,
    required this.onBookingConfirmed,
  });

  @override
  State<AppointmentBookingDialog> createState() =>
      _AppointmentBookingDialogState();
}

class _AppointmentBookingDialogState extends State<AppointmentBookingDialog> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _patientNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _dateController = TextEditingController();
  final _contactController = TextEditingController();

  // Track if date validation failed
  bool _showDateError = false;

  @override
  void dispose() {
    _patientNameController.dispose();
    _ageController.dispose();
    _symptomsController.dispose();
    _dateController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  /// Opens date and time picker
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0077B6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF0077B6),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Color(0xFF1A1A2E),
              ),
            ),
            child: child!,
          );
        },
      );

      // If time picker was cancelled, default to 10:00 AM so the picked date is not lost
      final TimeOfDay timeToUse = pickedTime ?? const TimeOfDay(hour: 10, minute: 0);
      final String formattedDateTime =
          '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year} ${timeToUse.format(context)}';

      setState(() {
        _dateController.text = formattedDateTime;
        _showDateError = false;
      });
    }
  }

  /// Validates and submits the booking
  void _submitBooking() {
    final formValid = _formKey.currentState!.validate();
    
    // Validate date selection separately as it's not a TextFormField
    if (_dateController.text.isEmpty) {
      setState(() {
        _showDateError = true;
      });
    }

    if (formValid && !_showDateError && _dateController.text.isNotEmpty) {
      // Create appointment object
      final appointment = AppointmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientName: _patientNameController.text,
        age: int.parse(_ageController.text),
        symptoms: _symptomsController.text,
        appointmentDate: _dateController.text,
        contactNumber: _contactController.text,
        doctorName: widget.doctor.name,
        doctorId: widget.doctor.id,
        status: 'Pending',
      );

      // Add to appointments list
      appointmentBookings.add(appointment);

      // Call callback
      widget.onBookingConfirmed(appointment);

      // Close dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '✓ Appointment Request Sent Successfully',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF4CAF50),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0077B6).withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Header with Close Button ----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Book Appointment',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade100,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // ---- Doctor Info ----
                  Text(
                    'With ${widget.doctor.name}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---- Patient Name Field ----
                  _buildTextFormField(
                    controller: _patientNameController,
                    label: 'Patient Name',
                    hint: 'Enter your full name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ---- Age Field ----
                  _buildTextFormField(
                    controller: _ageController,
                    label: 'Age',
                    hint: 'Enter your age',
                    icon: Icons.cake,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ---- Symptoms Field ----
                  _buildTextFormField(
                    controller: _symptomsController,
                    label: 'Problem/Symptoms',
                    hint: 'Describe your symptoms',
                    icon: Icons.medical_services_outlined,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe your symptoms';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ---- Appointment Date & Time Field ----
                  GestureDetector(
                    onTap: () => _selectDateTime(context),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _showDateError ? const Color(0xFFE53935) : Colors.grey.shade300,
                          width: _showDateError ? 2.0 : 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: _showDateError ? const Color(0xFFE53935) : const Color(0xFF0077B6),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Appointment Date & Time',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _showDateError ? const Color(0xFFE53935) : Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _dateController.text.isEmpty
                                        ? 'Select date and time'
                                        : _dateController.text,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _dateController.text.isEmpty
                                          ? Colors.grey.shade500
                                          : const Color(0xFF1A1A2E),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (_showDateError)
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 6),
                      child: Text(
                        'Please select appointment date and time',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontSize: 12,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // ---- Contact Number Field ----
                  _buildTextFormField(
                    controller: _contactController,
                    label: 'Contact Number',
                    hint: '+91 98765 xxxxx',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your contact number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // ---- Action Buttons ----
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(
                              color: Color(0xFF0077B6),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0077B6),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Confirm Button
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0077B6).withOpacity(0.3),
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
                                    Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Confirm Booking',
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
      ),
    );
  }

  /// Helper widget to build text form fields
  Widget _buildTextFormField({
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
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          color: Color(0xFF0077B6),
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF0077B6),
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF0077B6),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE53935),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
