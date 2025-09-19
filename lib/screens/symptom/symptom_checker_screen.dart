import 'package:flutter/material.dart';
import '../../utils/language_manager.dart';
import '../../utils/theme.dart';

class SymptomCheckerScreen extends StatefulWidget {
  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  String currentLanguage = 'en';
  int step = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'q': 'Do you have a fever?',
      'options': ['Yes', 'No'],
    },
    {
      'q': 'Are you experiencing cough?',
      'options': ['Yes', 'No'],
    },
    {
      'q': 'Do you have body ache?',
      'options': ['Yes', 'No'],
    },
  ];

  final Map<int, String> answers = {};

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
      appBar: AppBar(title: Text(LanguageManager.translate('symptom_checker', currentLanguage))),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (step < questions.length) {
      final q = questions[step];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Q${step + 1}/${questions.length}', style: TextStyle(color: SEHATTheme.textSecondary)),
          SizedBox(height: 8),
          Text(q['q'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: SEHATTheme.textPrimary)),
          SizedBox(height: 16),
          ...List.generate((q['options'] as List<String>).length, (i) {
            final opt = q['options'][i];
            final selected = answers[step] == opt;
            return GestureDetector(
              onTap: () => setState(() => answers[step] = opt),
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected ? SEHATTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected ? SEHATTheme.primaryColor : Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? Colors.white : SEHATTheme.primaryColor),
                    SizedBox(width: 12),
                    Text(opt, style: TextStyle(color: selected ? Colors.white : SEHATTheme.textPrimary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          }),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: step == 0 ? null : () => setState(() => step -= 1),
                  child: Text(LanguageManager.translate('back', currentLanguage)),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: answers.containsKey(step) ? () => setState(() => step += 1) : null,
                  child: Text(step == questions.length - 1 ? LanguageManager.translate('finish', currentLanguage) : LanguageManager.translate('next', currentLanguage)),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Results
    final yesCount = answers.values.where((v) => v == 'Yes').length;
    final possibleConditions = yesCount >= 2 ? ['Viral Fever / Flu'] : ['Mild Cold'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LanguageManager.translate('possible_conditions', currentLanguage), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: SEHATTheme.textPrimary)),
          SizedBox(height: 12),
          ...possibleConditions.map((c) => Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                child: Row(
                  children: [Icon(Icons.info, color: SEHATTheme.primaryColor), SizedBox(width: 8), Expanded(child: Text(c))],
                ),
              )),
          SizedBox(height: 16),
          Text(LanguageManager.translate('recommendations', currentLanguage), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: SEHATTheme.textPrimary)),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: SEHATTheme.cardColor, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Icon(Icons.call, color: SEHATTheme.primaryColor), SizedBox(width: 8), Text(LanguageManager.translate('consult_doctor', currentLanguage))]),
                SizedBox(height: 8),
                Row(children: [Icon(Icons.spa, color: SEHATTheme.accentColor), SizedBox(width: 8), Text(LanguageManager.translate('home_remedies', currentLanguage))]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


