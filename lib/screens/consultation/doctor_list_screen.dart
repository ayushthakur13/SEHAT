import 'package:flutter/material.dart';
import '../../utils/language_manager.dart';
import '../../utils/theme.dart';
import '../../widgets/ui.dart';
import 'consultation_booking_screen.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  String currentLanguage = 'en';
  String selectedFilter = 'all';
  final TextEditingController _searchCtrl = TextEditingController();
  String searchQuery = '';

  final List<Map<String, dynamic>> doctors = [
    {
      'id': '1',
      'name': 'Dr. Rajesh Kumar',
      'specialization': 'General Practitioner',
      'rating': 4.8,
      'experience': 12,
      'fee': 500,
      'availableToday': true,
      'availableTomorrow': true,
      'image': 'assets/doctor1.jpg',
      'languages': ['Hindi', 'English'],
    },
    {
      'id': '2',
      'name': 'Dr. Priya Sharma',
      'specialization': 'Cardiologist',
      'rating': 4.9,
      'experience': 15,
      'fee': 800,
      'availableToday': false,
      'availableTomorrow': true,
      'image': 'assets/doctor2.jpg',
      'languages': ['Hindi', 'English', 'Punjabi'],
    },
    {
      'id': '3',
      'name': 'Dr. Amrit Singh',
      'specialization': 'Pediatrician',
      'rating': 4.7,
      'experience': 10,
      'fee': 600,
      'availableToday': true,
      'availableTomorrow': true,
      'image': 'assets/doctor3.jpg',
      'languages': ['Punjabi', 'Hindi', 'English'],
    },
    {
      'id': '4',
      'name': 'Dr. Sunita Devi',
      'specialization': 'Gynecologist',
      'rating': 4.9,
      'experience': 18,
      'fee': 700,
      'availableToday': false,
      'availableTomorrow': true,
      'image': 'assets/doctor4.jpg',
      'languages': ['Hindi', 'English'],
    },
    {
      'id': '5',
      'name': 'Dr. Harpreet Kaur',
      'specialization': 'General Practitioner',
      'rating': 4.6,
      'experience': 8,
      'fee': 450,
      'availableToday': true,
      'availableTomorrow': true,
      'image': 'assets/doctor5.jpg',
      'languages': ['Punjabi', 'English'],
    },
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
    final filtered = doctors.where((d) {
      final spec = (d['specialization'] as String).toLowerCase();
      final name = (d['name'] as String).toLowerCase();
      final matchesFilter = selectedFilter == 'all'
          ? true
          : (selectedFilter == 'general'
              ? spec.contains('general')
              : (selectedFilter == 'gyno'
                  ? spec.contains('gyne') || spec.contains('gyn')
                  : spec.contains('cardio')));
      final matchesSearch = searchQuery.isEmpty || spec.contains(searchQuery) || name.contains(searchQuery);
      return matchesFilter && matchesSearch;
    }).toList();

    return PrimaryScaffold(
      appBar: AppBar(title: Text(LanguageManager.translate('available_doctors', currentLanguage))),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SectionCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: 'Search doctor or specialization',
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildChipsRow(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final doctor = filtered[index];
                  return _buildDoctorCard(doctor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('all', 'All'),
          SizedBox(width: 8),
          _buildFilterChip('general', 'General'),
          SizedBox(width: 8),
          _buildFilterChip('gyno', 'Gyno'),
          SizedBox(width: 8),
          _buildFilterChip('cardio', 'Cardio'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? SEHATTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: isSelected ? SEHATTheme.primaryColor : Colors.grey.shade300),
          boxShadow: [if (isSelected) BoxShadow(color: SEHATTheme.primaryColor.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : SEHATTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 12)),
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Doctor Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: SEHATTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: SEHATTheme.primaryColor,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                
                // Doctor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: SEHATTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        doctor['specialization'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: SEHATTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '${doctor['rating']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: SEHATTheme.textPrimary,
                              ),
                            ),
                          ]),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.work, color: SEHATTheme.textSecondary, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '${doctor['experience']} ${LanguageManager.translate('experience', currentLanguage)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: SEHATTheme.textSecondary,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Availability Status
                SizedBox(
                  width: 96,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (doctor['availableToday'])
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: SEHATTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          LanguageManager.translate('available_today', currentLanguage),
                          style: TextStyle(
                            fontSize: 10,
                            color: SEHATTheme.successColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else if (doctor['availableTomorrow'])
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          LanguageManager.translate('available_tomorrow', currentLanguage),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    SizedBox(height: 8),
                    Text(
                      '₹${doctor['fee']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SEHATTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                ),
              ]
            ),
            
            SizedBox(height: 16),
            
            // Languages
            Wrap(
              spacing: 8,
              children: doctor['languages'].map<Widget>((lang) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: SEHATTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lang,
                    style: TextStyle(
                      fontSize: 12,
                      color: SEHATTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // View Profile
                    },
                    icon: Icon(Icons.person, size: 18),
                    label: Text(LanguageManager.translate('view_profile', currentLanguage)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultationBookingScreen(doctor: doctor),
                        ),
                      );
                    },
                    icon: Icon(Icons.video_call, size: 18),
                    label: Text(LanguageManager.translate('book_now', currentLanguage)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
