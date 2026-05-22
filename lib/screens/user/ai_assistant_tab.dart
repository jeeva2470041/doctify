import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/doctor_model.dart';
import '../../data/dummy_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/appointment_booking_dialog.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? recommendedSpecialization;
  final String? recommendedDuration;
  final List<DoctorModel>? matchedDoctors;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.recommendedSpecialization,
    this.recommendedDuration,
    this.matchedDoctors,
  });
}

class AiAssistantTab extends StatefulWidget {
  final UserModel user;

  const AiAssistantTab({
    super.key,
    required this.user,
  });

  @override
  State<AiAssistantTab> createState() => _AiAssistantTabState();
}

class _AiAssistantTabState extends State<AiAssistantTab> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<Map<String, String>> _quickTags = [
    {
      'label': '💓 Chest Pain',
      'symptoms': 'I am experiencing chest pain, tightness, and shortness of breath.',
    },
    {
      'label': '🧠 Severe Headache',
      'symptoms': 'I have a severe headache, dizziness, and feeling lightheaded.',
    },
    {
      'label': '🩺 Persistent Fever',
      'symptoms': 'I have had a high fever and a persistent dry cough for the last two days.',
    },
    {
      'label': '🦵 Joint & Knee Pain',
      'symptoms': 'My left knee is swollen and there is chronic joint pain when walking.',
    },
    {
      'label': '🧴 Skin Rash / Itch',
      'symptoms': 'I have an itchy red skin rash spreading on my arms.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      ChatMessage(
        text: "Hello! I am **Dockify AI**, your virtual health assistant. 🩺\n\nDescribe your symptoms below, or select a quick option. I'll analyze your description to match you with the right specialist and recommend the optimal consultation duration.",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;

      final response = _generateAiResponse(text);

      setState(() {
        _isTyping = false;
        _messages.add(response);
      });
      _scrollToBottom();
    });
  }

  ChatMessage _generateAiResponse(String symptoms) {
    final query = symptoms.toLowerCase();
    String specialization = 'General Physician';
    String duration = '15 Mins';
    String textResult = '';

    if (query.contains('chest') || query.contains('heart') || query.contains('breath') || query.contains('cardio') || query.contains('tightness')) {
      specialization = 'Cardiologist';
      duration = '45 Mins';
      textResult = "Based on your report of **chest tightness or discomfort**, I strongly recommend consulting a **Cardiologist**.\n\n"
          "**Recommended Duration: 45 Mins**\n"
          "Cardiac evaluations require a thorough review of medical history, baseline vitals, and potential ECG diagnostic discussions, which fit best in a 45-minute window.";
    } else if (query.contains('headache') || query.contains('dizzy') || query.contains('brain') || query.contains('migraine') || query.contains('neurolog')) {
      specialization = 'Neurologist';
      duration = '45 Mins';
      textResult = "Based on your symptoms of a **severe headache or dizziness**, I recommend scheduling a consultation with a **Neurologist**.\n\n"
          "**Recommended Duration: 45 Mins**\n"
          "Neurological evaluations involve detailed motor-skill examinations, cranial nerve checks, and symptom progression review, making a 45-minute consultation optimal.";
    } else if (query.contains('skin') || query.contains('rash') || query.contains('itch') || query.contains('acne') || query.contains('dermatolog')) {
      specialization = 'Dermatologist';
      duration = '15 Mins';
      textResult = "For your **skin rash or dermatological irritation**, I recommend consulting a **Dermatologist**.\n\n"
          "**Recommended Duration: 15 Mins**\n"
          "Most initial skin consultations focus on visual inspection of the affected area, allowing quick identification and treatment prescription within 15 minutes.";
    } else if (query.contains('joint') || query.contains('knee') || query.contains('bone') || query.contains('back pain') || query.contains('orthopedic')) {
      specialization = 'Orthopedic Surgeon';
      duration = '30 Mins';
      textResult = "For your symptoms relating to **joint or knee pain**, I suggest consulting an **Orthopedic Surgeon**.\n\n"
          "**Recommended Duration: 30 Mins**\n"
          "A 30-minute session provides sufficient time for visual analysis, range of motion tests, and outlining physical therapy or imaging steps.";
    } else if (query.contains('child') || query.contains('baby') || query.contains('kid') || query.contains('pediatrician')) {
      specialization = 'Pediatrician';
      duration = '15 Mins';
      textResult = "For health issues involving **children**, a consultation with a **Pediatrician** is advised.\n\n"
          "**Recommended Duration: 15 Mins**\n"
          "A 15-minute consultation is typical for checking common pediatric symptoms, fever logs, and prescribing appropriate dosages.";
    } else if (query.contains('fever') || query.contains('cough') || query.contains('cold') || query.contains('flu')) {
      // General Physician is good, let's recommend Pediatrician or General Physician
      specialization = 'Pediatrician'; // Or General Physician. Since we have Pediatrician in dummyDoctors, let's match Pediatrician or General Physician.
      duration = '15 Mins';
      textResult = "For symptoms of **fever or persistent cough**, I recommend scheduling a consult with a doctor. A **Pediatrician** is recommended for kids, otherwise a General Physician is suitable.\n\n"
          "**Recommended Duration: 15 Mins**\n"
          "Standard evaluations for viral symptoms can be comprehensively managed with checkups and prescription planning in 15 minutes.";
    } else {
      specialization = 'General Physician';
      duration = '15 Mins';
      textResult = "Based on your symptoms, a consult with a general care physician or **General Physician** is the best starting point.\n\n"
          "**Recommended Duration: 15 Mins**\n"
          "A standard 15-minute session is perfect for a primary checkup, symptom review, and initial prescription or referral.";
    }

    // Filter dummyDoctors by specialization
    // Note: If no doctors are found, default to finding any available doctor.
    List<DoctorModel> matches = dummyDoctors
        .where((doc) => doc.specialization.toLowerCase() == specialization.toLowerCase())
        .toList();

    if (matches.isEmpty) {
      matches = dummyDoctors.take(2).toList();
    }

    return ChatMessage(
      text: textResult,
      isUser: false,
      timestamp: DateTime.now(),
      recommendedSpecialization: specialization,
      recommendedDuration: duration,
      matchedDoctors: matches,
    );
  }

  void _openBookingDialog(DoctorModel doctor, String duration, String symptoms) {
    showDialog(
      context: context,
      builder: (context) => AppointmentBookingDialog(
        doctor: doctor,
        initialDuration: duration,
        initialSymptoms: symptoms,
        onBookingConfirmed: (appointment) {
          // Navigate to Bookings Tab in UserHomeLayout if possible
          // In this simple demo, confirming booking displays a toast and adds to the list
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.psychology, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text('Dockify AI Consult'),
          ],
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Quick Tags (Only show when there is a welcome message or ready for new inputs)
          if (!_isTyping) _buildQuickTagsSection(),

          // Input field
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildQuickTagsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'Quick Symptom Tags',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickTags.map((tag) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ActionChip(
                    label: Text(tag['label']!),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: AppColors.primary.withOpacity(0.06),
                    side: const BorderSide(color: AppColors.primary, width: 0.8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    onPressed: () => _handleSendMessage(tag['symptoms']!),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      color: AppColors.cardBg,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _textController,
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Describe symptoms here...',
                  hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
                  border: InputBorder.none,
                ),
                onSubmitted: _handleSendMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: () => _handleSendMessage(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Column(
          crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Bubble card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: msg.isUser ? AppColors.primaryGradient : null,
                color: msg.isUser ? null : AppColors.cardBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  color: msg.isUser ? Colors.white : AppColors.textPrimary,
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
            ),

            // Time and details
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                _formatTime(msg.timestamp),
                style: TextStyle(fontSize: 10, color: AppColors.textHint),
              ),
            ),

            // Matched Doctors section
            if (!msg.isUser && msg.matchedDoctors != null && msg.matchedDoctors!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 6),
                child: Text(
                  'Recommended Available Specialists:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: msg.matchedDoctors!.length,
                  itemBuilder: (context, index) {
                    final doc = msg.matchedDoctors![index];
                    return _buildDoctorChatCard(doc, msg.recommendedDuration ?? '30 Mins', msg.text);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorChatCard(DoctorModel doctor, String duration, String symptoms) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    doctor.name.replaceFirst('Dr. ', '').isEmpty
                        ? 'D'
                        : doctor.name.replaceFirst('Dr. ', '')[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${doctor.specialization} • ${doctor.experience}',
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFF9500)),
              const SizedBox(width: 2),
              Text(
                doctor.rating.toString(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 8),
              Icon(Icons.local_hospital_outlined, size: 11, color: AppColors.textSecondary),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  doctor.hospitalName,
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: ElevatedButton(
              onPressed: () => _openBookingDialog(doctor, duration, symptoms),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Book $duration Consult',
                style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Dockify AI is analyzing...',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
