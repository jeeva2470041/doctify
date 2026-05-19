import os

file_path = r'c:\Users\priya\jeeva_project\dockify\lib\widgets\appointment_booking_dialog.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Normalize line endings to avoid matching issues
content = content.replace('\r\n', '\n')

# 1. Add _showDateError to state
target1 = '''class _AppointmentBookingDialogState extends State<AppointmentBookingDialog> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _patientNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _dateController = TextEditingController();
  final _contactController = TextEditingController();'''

replace1 = '''class _AppointmentBookingDialogState extends State<AppointmentBookingDialog> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _patientNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _dateController = TextEditingController();
  final _contactController = TextEditingController();

  // Track if date validation failed
  bool _showDateError = false;'''

content = content.replace(target1, replace1)

# 2. Modify _selectDateTime
target2 = '''      if (pickedTime != null) {
        final String formattedDateTime =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year} ${pickedTime.format(context)}';

        setState(() {
          _dateController.text = formattedDateTime;
        });
      }'''

replace2 = '''      // If time picker was cancelled, default to 10:00 AM so the picked date is not lost
      final TimeOfDay timeToUse = pickedTime ?? const TimeOfDay(hour: 10, minute: 0);
      final String formattedDateTime =
          '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year} ${timeToUse.format(context)}';

      setState(() {
        _dateController.text = formattedDateTime;
        _showDateError = false;
      });'''

content = content.replace(target2, replace2)

# 3. Modify _submitBooking
target3 = '''  /// Validates and submits the booking
  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      // Create appointment object
      final appointment = AppointmentModel('''

replace3 = '''  /// Validates and submits the booking
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
      final appointment = AppointmentModel('''

content = content.replace(target3, replace3)

# 4. Modify the UI for Date Picker
target4 = '''                  // ---- Appointment Date & Time Field ----
                  GestureDetector(
                    onTap: () => _selectDateTime(context),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
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
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Color(0xFF0077B6),
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
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),'''

replace4 = '''                  // ---- Appointment Date & Time Field ----
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
                                  ),'''

content = content.replace(target4, replace4)

# 5. Add Error text below date picker
target5 = '''                  const SizedBox(height: 16),

                  // ---- Contact Number Field ----'''

replace5 = '''                  if (_showDateError)
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

                  // ---- Contact Number Field ----'''

content = content.replace(target5, replace5)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Modifications applied successfully")
