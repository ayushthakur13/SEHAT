import 'package:flutter/material.dart';
import '../../utils/language_manager.dart';
import '../../utils/theme.dart';
import '../../utils/storage.dart';

class HealthRecordsScreen extends StatefulWidget {
  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  String currentLanguage = 'en';
  List<Map<String, dynamic>> prescriptions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final lang = await LanguageManager.getLanguage();
    final items = await StorageService.getPrescriptions();
    setState(() {
      currentLanguage = lang;
      prescriptions = items.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SEHATTheme.backgroundColor,
      appBar: AppBar(title: Text(LanguageManager.translate('health_records', currentLanguage))),
      body: prescriptions.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: prescriptions.length,
              itemBuilder: (context, i) => _buildPrescriptionCard(prescriptions[i]),
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_off, size: 56, color: SEHATTheme.textSecondary),
          SizedBox(height: 12),
          Text(LanguageManager.translate('offline_available', currentLanguage), style: TextStyle(color: SEHATTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(Map<String, dynamic> p) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: SEHATTheme.primaryColor),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  p['doctorName'] ?? '-',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: SEHATTheme.textPrimary),
                ),
              ),
              Text(p['date'] ?? '', style: TextStyle(color: SEHATTheme.textSecondary, fontSize: 12)),
            ],
          ),
          SizedBox(height: 8),
          if ((p['medicines'] as List<dynamic>?)?.isNotEmpty == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageManager.translate('medicines', currentLanguage), style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 6),
                ...List<Widget>.from((p['medicines'] as List<dynamic>).map((m) => Row(
                      children: [
                        Icon(Icons.medication, size: 16, color: SEHATTheme.textSecondary),
                        SizedBox(width: 6),
                        Expanded(child: Text(m.toString())),
                      ],
                    ))),
              ],
            ),
          if ((p['notes'] ?? '').toString().isNotEmpty) ...[
            SizedBox(height: 8),
            Text(LanguageManager.translate('notes', currentLanguage), style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text(p['notes']),
          ],
        ],
      ),
    );
  }
}


