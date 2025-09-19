import 'package:flutter/material.dart';
import '../../utils/pharmacy_storage.dart';
import '../../utils/theme.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Set<String> favs = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    favs = await PharmacyStorage.getFavorites();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: favs.isEmpty ? _empty() : ListView(
        padding: EdgeInsets.all(16),
        children: favs.map((id) => _favTile(id)).toList(),
      ),
    );
  }

  Widget _empty() => Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No favorites yet', style: TextStyle(color: SEHATTheme.textSecondary))));

  Widget _favTile(String id) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: Row(
        children: [
          Icon(Icons.medication, color: SEHATTheme.primaryColor),
          SizedBox(width: 8),
          Expanded(child: Text('Medicine $id')),
          IconButton(onPressed: () async { await PharmacyStorage.toggleFavorite(id); _load(); }, icon: Icon(Icons.delete_outline, color: SEHATTheme.errorColor)),
        ],
      ),
    );
  }
}


