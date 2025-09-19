import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/pharmacy_storage.dart';

class PharmacyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> pharmacy;
  const PharmacyDetailScreen({super.key, required this.pharmacy});
  @override
  State<PharmacyDetailScreen> createState() => _PharmacyDetailScreenState();
}

class _PharmacyDetailScreenState extends State<PharmacyDetailScreen> {
  final List<Map<String, dynamic>> medicines = [
    {'id': 'med1', 'name': 'Paracetamol 500mg', 'price': 25, 'inStock': true},
    {'id': 'med2', 'name': 'Amoxicillin 250mg', 'price': 120, 'inStock': false},
    {'id': 'med3', 'name': 'Vitamin C 500mg', 'price': 90, 'inStock': true},
  ];

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
    return Scaffold(
      appBar: AppBar(title: Text(widget.pharmacy['name'])),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _infoCard(),
          SizedBox(height: 12),
          ...medicines.map(_medicineTile),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(Icons.local_pharmacy, color: SEHATTheme.primaryColor), SizedBox(width: 8), Expanded(child: Text(widget.pharmacy['name'], style: TextStyle(fontWeight: FontWeight.w600)))]),
          SizedBox(height: 8),
          Row(children: [Icon(Icons.place, size: 16, color: SEHATTheme.textSecondary), SizedBox(width: 4), Expanded(child: Text(widget.pharmacy['address'] ?? ''))]),
          SizedBox(height: 8),
          Row(children: [Icon(Icons.call, size: 16, color: SEHATTheme.textSecondary), SizedBox(width: 4), Text(widget.pharmacy['contact'] ?? '')]),
          SizedBox(height: 8),
          Row(children: [Icon(Icons.schedule, size: 16, color: SEHATTheme.textSecondary), SizedBox(width: 4), Text('Timings: 9:00 AM - 9:00 PM')]),
          SizedBox(height: 12),
          Row(children: [
            ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.call), label: Text('Call Pharmacy')),
          ]),
        ],
      ),
    );
  }

  Widget _medicineTile(Map<String, dynamic> m) {
    final isFav = favorites.contains(m['id']);
    final toNotify = notifyList.contains(m['id']);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m['name'], style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Row(children: [
                Text('₹${m['price']}', style: TextStyle(color: SEHATTheme.textPrimary)),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (m['inStock'] ? SEHATTheme.successColor : SEHATTheme.errorColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(m['inStock'] ? 'In Stock' : 'Out of Stock', style: TextStyle(color: m['inStock'] ? SEHATTheme.successColor : SEHATTheme.errorColor, fontWeight: FontWeight.w600, fontSize: 12)),
                ),
              ]),
            ]),
          ),
          IconButton(onPressed: () async { await PharmacyStorage.toggleFavorite(m['id']); _load(); }, icon: Icon(isFav ? Icons.star : Icons.star_border, color: isFav ? Colors.amber : SEHATTheme.textSecondary)),
          IconButton(onPressed: () => _reserve(m), icon: Icon(Icons.inventory_2_outlined, color: SEHATTheme.primaryColor)),
          IconButton(onPressed: () async { await PharmacyStorage.toggleNotify(m['id']); _load(); }, icon: Icon(toNotify ? Icons.notifications_active : Icons.notifications_none, color: toNotify ? SEHATTheme.primaryColor : SEHATTheme.textSecondary)),
        ],
      ),
    );
  }

  void _reserve(Map<String, dynamic> m) async {
    int qty = 1;
    TimeOfDay time = TimeOfDay.now();
    await showDialog(context: context, builder: (ctx) {
      return StatefulBuilder(builder: (ctx, setState) {
        return AlertDialog(
          title: Text('Reserve / Book'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(children: [Text('Quantity'), Spacer(), IconButton(onPressed: () => setState(() => qty = (qty > 1) ? qty - 1 : 1), icon: Icon(Icons.remove_circle_outline)), Text('$qty'), IconButton(onPressed: () => setState(() => qty += 1), icon: Icon(Icons.add_circle_outline))]),
            SizedBox(height: 8),
            Row(children: [Text('Pickup Time'), Spacer(), TextButton(onPressed: () async { final picked = await showTimePicker(context: context, initialTime: time); if (picked != null) setState(() => time = picked); }, child: Text(time.format(context)))]),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
            ElevatedButton(onPressed: () async {
              await PharmacyStorage.addReservation({'pharmacy': widget.pharmacy['name'], 'medicine': m['name'], 'qty': qty, 'time': time.format(context)});
              if (mounted) Navigator.pop(ctx);
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your medicine has been reserved at ${widget.pharmacy['name']}.')));
            }, child: Text('Confirm')),
          ],
        );
      });
    });
  }
}


