import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/medicine_reminder_model.dart';
import '../../services/reminder_service.dart';
import '../../theme/app_colors.dart';

class ReminderTab extends StatefulWidget {
  const ReminderTab({super.key});

  @override
  State<ReminderTab> createState() => _ReminderTabState();
}

class _ReminderTabState extends State<ReminderTab> {
  final _reminderService = ReminderService();

  @override
  void initState() {
    super.initState();
    _reminderService.init();
    _reminderService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _reminderService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController timeController) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (mounted) {
        timeController.text = picked.format(context);
      }
    }
  }

  void _showAddEditReminderSheet({MedicineReminderModel? existingReminder}) {
    final isEdit = existingReminder != null;
    final nameController = TextEditingController(text: existingReminder?.medicineName ?? '');
    final dosageController = TextEditingController(text: existingReminder?.dosage ?? '');
    final timeController = TextEditingController(text: existingReminder?.time ?? '');
    final notesController = TextEditingController(text: existingReminder?.notes ?? '');
    String selectedFrequency = existingReminder?.frequency ?? 'Daily';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          isEdit ? Icons.edit_calendar_rounded : Icons.add_alarm_rounded,
                          color: AppColors.primary,
                          size: 26,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isEdit ? 'Edit Reminder' : 'Add Medicine Reminder',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Medicine Name Input
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Medicine Name',
                        prefixIcon: Icon(Icons.medication_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dosage Input
                    TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Dosage (e.g. 1 Tablet, 500mg, 5ml)',
                        prefixIcon: Icon(Icons.healing_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Time Picker
                    TextField(
                      controller: timeController,
                      readOnly: true,
                      onTap: () => _selectTime(context, timeController),
                      decoration: const InputDecoration(
                        labelText: 'Scheduled Time',
                        prefixIcon: Icon(Icons.access_time_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Frequency Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedFrequency,
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        prefixIcon: Icon(Icons.repeat_rounded),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                        DropdownMenuItem(value: 'Morning Only', child: Text('Morning Only')),
                        DropdownMenuItem(value: 'Afternoon Only', child: Text('Afternoon Only')),
                        DropdownMenuItem(value: 'Night Only', child: Text('Night Only')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setSheetState(() {
                            selectedFrequency = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Notes
                    TextField(
                      controller: notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Notes / Instructions (optional)',
                        prefixIcon: Icon(Icons.description_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameController.text.trim().isEmpty ||
                                  dosageController.text.trim().isEmpty ||
                                  timeController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill out Name, Dosage, and Time.')),
                                );
                                return;
                              }

                              final reminder = MedicineReminderModel(
                                id: isEdit ? existingReminder.id : const Uuid().v4(),
                                medicineName: nameController.text.trim(),
                                dosage: dosageController.text.trim(),
                                time: timeController.text.trim(),
                                frequency: selectedFrequency,
                                status: isEdit ? existingReminder.status : 'Pending',
                                notes: notesController.text.trim().isEmpty
                                    ? null
                                    : notesController.text.trim(),
                              );

                              if (isEdit) {
                                _reminderService.updateReminder(reminder);
                              } else {
                                _reminderService.addReminder(reminder);
                              }

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isEdit
                                      ? 'Reminder updated successfully!'
                                      : 'Reminder added successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(isEdit ? 'Save Changes' : 'Add Reminder'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Taken':
        return AppColors.available;
      case 'Missed':
        return AppColors.busy;
      case 'Pending':
      default:
        return AppColors.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _reminderService.reminders;
    final total = reminders.length;
    final taken = reminders.where((r) => r.status == 'Taken').length;
    final missed = reminders.where((r) => r.status == 'Missed').length;
    final pending = reminders.where((r) => r.status == 'Pending').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowCard,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                            'Medicine Reminders',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Track your daily health routines',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      IconButton.filledTonal(
                        onPressed: () => _showAddEditReminderSheet(),
                        icon: const Icon(Icons.add_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Dashboard Stats Bar
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Total', total.toString(), Colors.blue),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatItem('Taken', taken.toString(), AppColors.available),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatItem('Pending', pending.toString(), AppColors.pending),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatItem('Missed', missed.toString(), AppColors.busy),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Reminders List
            Expanded(
              child: reminders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medication_liquid_rounded, size: 64, color: AppColors.textHint),
                          const SizedBox(height: 12),
                          Text(
                            'No reminders scheduled.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap the Add button to create a new reminder.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminders[index];
                        final statusColor = _getStatusColor(reminder.status);

                        return Card(
                          color: AppColors.cardBg,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: statusColor.withOpacity(0.2), width: 1.5),
                          ),
                          elevation: 1.5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reminder.medicineName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.healing_rounded,
                                                  size: 14, color: AppColors.textSecondary),
                                              const SizedBox(width: 4),
                                              Text(
                                                reminder.dosage,
                                                style: TextStyle(
                                                  fontSize: 12.5,
                                                  color: AppColors.textSecondary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: statusColor.withOpacity(0.4), width: 1),
                                      ),
                                      child: Text(
                                        reminder.status,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      reminder.time,
                                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Icons.repeat_rounded, size: 14, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      reminder.frequency,
                                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                if (reminder.notes != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    '💡 ${reminder.notes}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                // Action row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_rounded, size: 18),
                                      onPressed: () =>
                                          _showAddEditReminderSheet(existingReminder: reminder),
                                      tooltip: 'Edit Reminder',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                                      onPressed: () => _reminderService.deleteReminder(reminder.id),
                                      tooltip: 'Delete Reminder',
                                    ),
                                    const Spacer(),
                                    if (reminder.status != 'Taken')
                                      TextButton.icon(
                                        onPressed: () => _reminderService.updateReminderStatus(
                                            reminder.id, 'Taken'),
                                        icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                                        label: const Text('Mark as Taken'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColors.available,
                                        ),
                                      )
                                    else
                                      TextButton.icon(
                                        onPressed: () => _reminderService.updateReminderStatus(
                                            reminder.id, 'Pending'),
                                        icon: const Icon(Icons.undo_rounded, size: 16),
                                        label: const Text('Undo Taken'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColors.pending,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add_reminder_fab'),
        onPressed: () => _showAddEditReminderSheet(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alarm_rounded),
        label: const Text('Add Reminder'),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
