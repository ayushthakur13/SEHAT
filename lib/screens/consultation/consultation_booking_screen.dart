import 'package:flutter/material.dart';
import '../../utils/language_manager.dart';
import '../../utils/theme.dart';
import 'consultation_screen.dart';

class ConsultationBookingScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const ConsultationBookingScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  _ConsultationBookingScreenState createState() => _ConsultationBookingScreenState();
}

class _ConsultationBookingScreenState extends State<ConsultationBookingScreen> {
  String currentLanguage = 'en';
  String selectedCallType = 'video';
  String selectedTimeSlot = '';

  final List<String> timeSlots = [
    '9:00 AM - 9:30 AM',
    '9:30 AM - 10:00 AM',
    '10:00 AM - 10:30 AM',
    '10:30 AM - 11:00 AM',
    '2:00 PM - 2:30 PM',
    '2:30 PM - 3:00 PM',
    '3:00 PM - 3:30 PM',
    '3:30 PM - 4:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  _loadLanguage() async {
    final lang = await LanguageManager.getLanguage();
    setState(() {
      currentLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SEHATTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Book Consultation'),
        backgroundColor: SEHATTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info Card
            _buildDoctorInfoCard(),
            SizedBox(height: 24),
            
            // Call Type Selection
            _buildCallTypeSection(),
            SizedBox(height: 24),
            
            // Time Slot Selection
            _buildTimeSlotSection(),
            SizedBox(height: 24),
            
            // Consultation Details
            _buildConsultationDetails(),
            SizedBox(height: 32),
            
            // Book Button
            _buildBookButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: SEHATTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: SEHATTheme.primaryColor,
              size: 40,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor['name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: SEHATTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.doctor['specialization'],
                  style: TextStyle(
                    fontSize: 16,
                    color: SEHATTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '${widget.doctor['rating']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: SEHATTheme.textPrimary,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.work, color: SEHATTheme.textSecondary, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '${widget.doctor['experience']} years',
                      style: TextStyle(
                        fontSize: 16,
                        color: SEHATTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Call Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: SEHATTheme.textPrimary,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildCallTypeOption(
                'video',
                Icons.video_call,
                'Video Call',
                'Face-to-face consultation',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildCallTypeOption(
                'audio',
                Icons.call,
                'Audio Call',
                'Voice consultation',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCallTypeOption(String type, IconData icon, String title, String subtitle) {
    final isSelected = selectedCallType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCallType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? SEHATTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? SEHATTheme.primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : SEHATTheme.primaryColor,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : SEHATTheme.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white.withOpacity(0.8) : SEHATTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time Slot',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: SEHATTheme.textPrimary,
          ),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            final timeSlot = timeSlots[index];
            final isSelected = selectedTimeSlot == timeSlot;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTimeSlot = timeSlot;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? SEHATTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? SEHATTheme.primaryColor : Colors.grey.shade300,
                  ),
                ),
                child: Center(
                  child: Text(
                    timeSlot,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : SEHATTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildConsultationDetails() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SEHATTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consultation Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: SEHATTheme.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          _buildDetailRow('Doctor', widget.doctor['name']),
          _buildDetailRow('Specialization', widget.doctor['specialization']),
          _buildDetailRow('Call Type', selectedCallType == 'video' ? 'Video Call' : 'Audio Call'),
          _buildDetailRow('Time Slot', selectedTimeSlot.isEmpty ? 'Not selected' : selectedTimeSlot),
          _buildDetailRow('Consultation Fee', '₹${widget.doctor['fee']}'),
          _buildDetailRow('Duration', '30 minutes'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: SEHATTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SEHATTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: selectedTimeSlot.isNotEmpty ? _bookConsultation : null,
        child: Text(
          'Book Consultation - ₹${widget.doctor['fee']}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _bookConsultation() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Booking'),
        content: Text('Are you sure you want to book this consultation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsultationScreen(
                    doctor: widget.doctor,
                    callType: selectedCallType,
                    timeSlot: selectedTimeSlot,
                  ),
                ),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
