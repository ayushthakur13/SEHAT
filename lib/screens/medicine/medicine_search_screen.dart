import 'package:flutter/material.dart';
import '../../utils/language_manager.dart';
import '../../utils/theme.dart';
import '../medicine/pharmacy_detail_screen.dart';

class MedicineSearchScreen extends StatefulWidget {
  @override
  State<MedicineSearchScreen> createState() => _MedicineSearchScreenState();
}

class _MedicineSearchScreenState extends State<MedicineSearchScreen> {
  String currentLanguage = 'en';
  final TextEditingController _controller = TextEditingController();
  String query = '';

  final List<Map<String, dynamic>> pharmacies = [
    {
      'name': 'Village Health Pharmacy',
      'distance': '1.2 km',
      'open': true,
      'stock': {'paracetamol': true, 'amoxicillin': false, 'vitamin c': true},
      'contact': '+91 98765 43210',
      'address': 'Main Bazaar, Rampura',
    },
    {
      'name': 'Sehat Chemist',
      'distance': '3.5 km',
      'open': false,
      'stock': {'paracetamol': true, 'amoxicillin': true, 'vitamin c': true},
      'contact': '+91 91234 56789',
      'address': 'Near Bus Stand, Kotli',
    },
    {
      'name': 'Rural Care Medicos',
      'distance': '6.8 km',
      'stock': {'paracetamol': false, 'amoxicillin': true, 'vitamin c': false},
      'contact': '+91 99887 76655',
      'address': 'Chowk Market, Naya Gaon',
    },
  ];

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
        title: Text(LanguageManager.translate('check_medicine', currentLanguage)),
      ),
      body: SafeArea(
        child: Padding(
        padding: EdgeInsets.only(left:16, right:16, top:16, bottom: 16 + 0),
        child: Column(
          children: [
            _searchBar(),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12),
                children: pharmacies.map((p) => _buildPharmacyCard(p)).toList(),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _searchBar() {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search by pharmacy or medicine',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => setState(() => query = v.toLowerCase()),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => setState(() => query = ''), icon: Icon(Icons.clear), label: Text('Clear'))),
            SizedBox(width: 8),
            Expanded(child: ElevatedButton.icon(onPressed: () => setState(() => query = _controller.text.toLowerCase()), icon: Icon(Icons.search), label: Text(LanguageManager.translate('search', currentLanguage))))
          ],
        )
      ],
    );
  }

  Widget _buildPharmacyCard(Map<String, dynamic> p) {
    final inStock = query.isEmpty ? null : (p['stock'][query] == true);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_pharmacy, color: SEHATTheme.primaryColor),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  p['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: SEHATTheme.textPrimary),
                ),
              ),
              Text(p['distance'], style: TextStyle(color: SEHATTheme.textSecondary)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.place, size: 16, color: SEHATTheme.textSecondary),
              SizedBox(width: 4),
              Expanded(
                child: Text(p['address'], style: TextStyle(fontSize: 12, color: SEHATTheme.textSecondary)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.call, size: 16, color: SEHATTheme.textSecondary),
              SizedBox(width: 4),
              Text(p['contact'], style: TextStyle(fontSize: 12, color: SEHATTheme.textSecondary)),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (p['open'] == true ? SEHATTheme.successColor : SEHATTheme.errorColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(p['open'] == true ? 'Open' : 'Closed', style: TextStyle(color: p['open'] == true ? SEHATTheme.successColor : SEHATTheme.errorColor, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ],
          ),
          if (inStock != null) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: inStock ? SEHATTheme.successColor.withOpacity(0.1) : SEHATTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(inStock ? Icons.check_circle : Icons.cancel, size: 16, color: inStock ? SEHATTheme.successColor : SEHATTheme.errorColor),
                  SizedBox(width: 6),
                  Text(
                    inStock ? LanguageManager.translate('in_stock', currentLanguage) : LanguageManager.translate('out_of_stock', currentLanguage),
                    style: TextStyle(color: inStock ? SEHATTheme.successColor : SEHATTheme.errorColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PharmacyDetailScreen(pharmacy: p))),
              child: Text('View Medicines'),
            ),
          ),
        ],
      ),
    );
  }
}


