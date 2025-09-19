import 'package:flutter/material.dart';
import '../../utils/language_manager.dart';
import '../../utils/theme.dart';
import '../../utils/storage.dart';

class ConsultationScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String callType; // 'video' or 'audio'
  final String timeSlot;

  const ConsultationScreen({Key? key, required this.doctor, required this.callType, required this.timeSlot}) : super(key: key);

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  String currentLanguage = 'en';
  bool inCall = true;
  bool prescriptionSaved = false;

  final TextEditingController notesController = TextEditingController();
  final TextEditingController medicinesController = TextEditingController(text: 'Paracetamol 500mg - 1 tab x 3/day');

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  _loadLanguage() async {
    final lang = await LanguageManager.getLanguage();
    setState(() => currentLanguage = lang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SEHATTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.callType == 'video' ? LanguageManager.translate('video_call', currentLanguage) : LanguageManager.translate('audio_call', currentLanguage)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCallArea(),
            SizedBox(height: 16),
            _buildActions(),
            SizedBox(height: 16),
            Expanded(child: _buildPrescriptionComposer()),
          ],
        ),
      ),
    );
  }

  Widget _buildCallArea() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.callType == 'video' ? Icons.videocam : Icons.call, size: 48, color: SEHATTheme.primaryColor),
            SizedBox(height: 8),
            Text(
              inCall ? 'In consultation with ${widget.doctor['name']}' : LanguageManager.translate('prescription_received', currentLanguage),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(widget.timeSlot, style: TextStyle(color: SEHATTheme.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(inCall ? Icons.call_end : Icons.call),
            label: Text(inCall ? 'End' : LanguageManager.translate('join_consultation', currentLanguage)),
            onPressed: () => setState(() => inCall = !inCall),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.save_alt),
            label: Text(LanguageManager.translate('save_to_records', currentLanguage)),
            onPressed: prescriptionSaved ? null : _savePrescription,
          ),
        ),
      ],
    );
  }

  Widget _buildPrescriptionComposer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LanguageManager.translate('prescription_received', currentLanguage), style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          TextField(
            controller: medicinesController,
            maxLines: 3,
            decoration: InputDecoration(labelText: LanguageManager.translate('medicines', currentLanguage)),
          ),
          SizedBox(height: 8),
          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: InputDecoration(labelText: LanguageManager.translate('notes', currentLanguage)),
          ),
        ],
      ),
    );
  }

  Future<void> _savePrescription() async {
    final now = DateTime.now();
    final payload = {
      'date': '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      'doctorName': widget.doctor['name'],
      'medicines': medicinesController.text.split('\n').where((l) => l.trim().isNotEmpty).toList(),
      'notes': notesController.text,
    };
    await StorageService.savePrescription(payload);
    setState(() => prescriptionSaved = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to offline records')));
    }
  }
}


