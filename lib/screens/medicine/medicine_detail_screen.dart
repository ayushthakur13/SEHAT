import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/pharmacy_storage.dart';

class MedicineDetailScreen extends StatefulWidget {
  final Map<String, dynamic> medicine;
  const MedicineDetailScreen({super.key, required this.medicine});
  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  Set<String> favorites = {};
  Set<String> notifyList = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    favorites = await PharmacyStorage.getFavorites();
    notifyList = await PharmacyStorage.getNotifyList();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.medicine;
    final fav = favorites.contains(m['id']);
    final notify = notifyList.contains(m['id']);
    return Scaffold(
      appBar: AppBar(title: Text(m['name'])),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
            child: Center(child: Icon(Icons.medication, size: 64, color: SEHATTheme.primaryColor)),
          ),
          SizedBox(height: 16),
          Text('Dosage: As directed by physician', style: TextStyle(color: SEHATTheme.textSecondary)),
          SizedBox(height: 12),
          Text('Alternatives', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Wrap(spacing: 8, children: [Chip(label: Text('Alt 1')), Chip(label: Text('Alt 2'))]),
          SizedBox(height: 16),
          Row(
            children: [
              IconButton(onPressed: () async { await PharmacyStorage.toggleFavorite(m['id']); _load(); }, icon: Icon(fav ? Icons.star : Icons.star_border, color: fav ? Colors.amber : SEHATTheme.textSecondary)),
              SizedBox(width: 8),
              ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.inventory_2_outlined), label: Text('Reserve')),
              SizedBox(width: 8),
              OutlinedButton.icon(onPressed: () async { await PharmacyStorage.toggleNotify(m['id']); _load(); }, icon: Icon(notify ? Icons.notifications_active : Icons.notifications_none), label: Text('Notify')),
            ],
          ),
        ],
      ),
    );
  }
}


