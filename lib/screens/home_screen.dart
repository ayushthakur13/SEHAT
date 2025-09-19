import 'package:flutter/material.dart';
import '../utils/language_manager.dart';
import '../utils/theme.dart';
import '../widgets/ui.dart';
import 'consultation/doctor_list_screen.dart';
import 'medicine/medicine_search_screen.dart';
import 'symptom/symptom_checker_screen.dart';
import 'records/health_records_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentLanguage = 'en';

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
    return PrimaryScaffold(
      appBar: AppBar(title: Text('SEHAT')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              SizedBox(height: 30),
              
              // Welcome Card
              _buildWelcomeCard(),
              SizedBox(height: 30),
              
              // Main Actions Grid
              _buildActionsGrid(),
              SizedBox(height: 30),
              
              // Quick Access Section
              _buildQuickAccessSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: SEHATTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.medical_services,
            color: Colors.white,
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LanguageManager.translate('welcome', currentLanguage),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: SEHATTheme.textPrimary,
                ),
              ),
              Text(
                LanguageManager.translate('welcome_subtitle', currentLanguage),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: SEHATTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          icon: Icon(Icons.person, color: SEHATTheme.primaryColor),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return SectionCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [SEHATTheme.primaryColor, SEHATTheme.primaryColor.withOpacity(0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Your Health, Our Priority', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Access quality care from home. Connect with doctors, check medicines, and manage records.', style: TextStyle(color: Colors.white.withOpacity(0.9))),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildActionCard(
          icon: Icons.video_call,
          title: LanguageManager.translate('book_consultation', currentLanguage),
          subtitle: 'Connect with doctors',
          color: SEHATTheme.primaryColor,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorListScreen()),
          ),
        ),
        _buildActionCard(
          icon: Icons.medication,
          title: LanguageManager.translate('check_medicine', currentLanguage),
          subtitle: 'Find nearby pharmacies',
          color: SEHATTheme.accentColor,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MedicineSearchScreen()),
          ),
        ),
        _buildActionCard(
          icon: Icons.psychology,
          title: LanguageManager.translate('symptom_checker', currentLanguage),
          subtitle: 'Quick health assessment',
          color: Color(0xFF9F7AEA),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SymptomCheckerScreen()),
          ),
        ),
        _buildActionCard(
          icon: Icons.folder_copy,
          title: LanguageManager.translate('health_records', currentLanguage),
          subtitle: 'View medical history',
          color: Color(0xFF38B2AC),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HealthRecordsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SectionCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: SEHATTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: SEHATTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: SEHATTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        Container(
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
              Icon(Icons.offline_bolt, color: SEHATTheme.successColor, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offline Mode Available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: SEHATTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Access your health records even without internet',
                      style: TextStyle(
                        fontSize: 12,
                        color: SEHATTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_circle, color: SEHATTheme.successColor, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
