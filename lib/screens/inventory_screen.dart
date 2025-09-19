import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Medicines',
    'Injections',
    'Oxygen Cylinders',
    'Medical Equipment',
    'Supplies',
  ];

  final List<Map<String, dynamic>> _inventory = [
    {
      'id': 'M001',
      'name': 'Paracetamol',
      'category': 'Medicines',
      'stock': 100,
      'minStock': 20,
      'unit': 'tablets',
      'expiryDate': '2024-12-31',
      'status': 'Available',
    },
    {
      'id': 'M002',
      'name': 'Ibuprofen',
      'category': 'Medicines',
      'stock': 15,
      'minStock': 20,
      'unit': 'tablets',
      'expiryDate': '2024-11-30',
      'status': 'Low Stock',
    },
    {
      'id': 'I001',
      'name': 'Insulin',
      'category': 'Injections',
      'stock': 50,
      'minStock': 10,
      'unit': 'vials',
      'expiryDate': '2024-10-15',
      'status': 'Available',
    },
    {
      'id': 'O001',
      'name': 'Oxygen Cylinder',
      'category': 'Oxygen Cylinders',
      'stock': 8,
      'minStock': 5,
      'unit': 'cylinders',
      'expiryDate': 'N/A',
      'status': 'Available',
    },
    {
      'id': 'E001',
      'name': 'Blood Pressure Monitor',
      'category': 'Medical Equipment',
      'stock': 3,
      'minStock': 2,
      'unit': 'units',
      'expiryDate': 'N/A',
      'status': 'Available',
    },
    {
      'id': 'S001',
      'name': 'Surgical Gloves',
      'category': 'Supplies',
      'stock': 5,
      'minStock': 10,
      'unit': 'boxes',
      'expiryDate': '2025-06-30',
      'status': 'Low Stock',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory & Resources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewItem,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshInventory,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search inventory items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                
                // Category Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF1976D2),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Inventory Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Items', '${_getFilteredInventory().length}', Icons.inventory, Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Low Stock', '${_getLowStockCount()}', Icons.warning, Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Out of Stock', '${_getOutOfStockCount()}', Icons.error, Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Inventory List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _getFilteredInventory().length,
              itemBuilder: (context, index) {
                final item = _getFilteredInventory()[index];
                return _buildInventoryCard(item);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _requestRefill,
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredInventory() {
    List<Map<String, dynamic>> filtered = _inventory;

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((item) => item['category'] == _selectedCategory).toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((item) {
        return item['name'].toString().toLowerCase().contains(query) ||
               item['id'].toString().toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  int _getLowStockCount() {
    return _inventory.where((item) => item['stock'] <= item['minStock']).length;
  }

  int _getOutOfStockCount() {
    return _inventory.where((item) => item['stock'] == 0).length;
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    final statusColor = _getStatusColor(item['status']);
    final isLowStock = item['stock'] <= item['minStock'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _viewItemDetails(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'ID: ${item['id']} • ${item['category']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLowStock)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'LOW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.inventory, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('Stock: ${item['stock']} ${item['unit']}'),
                  const SizedBox(width: 16),
                  Icon(Icons.warning, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('Min: ${item['minStock']} ${item['unit']}'),
                ],
              ),
              if (item['expiryDate'] != 'N/A') ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('Expiry: ${item['expiryDate']}'),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _requestRefillForItem(item),
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text('Request Refill'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateStock(item),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Update Stock'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange;
      case 'Out of Stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _viewItemDetails(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${item['id']}'),
            Text('Category: ${item['category']}'),
            Text('Current Stock: ${item['stock']} ${item['unit']}'),
            Text('Minimum Stock: ${item['minStock']} ${item['unit']}'),
            Text('Status: ${item['status']}'),
            if (item['expiryDate'] != 'N/A')
              Text('Expiry Date: ${item['expiryDate']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _requestRefillForItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Refill'),
        content: Text('Request refill for ${item['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Refill requested for ${item['name']}')),
              );
            },
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  void _updateStock(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Stock'),
        content: const Text('Stock update functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addNewItem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: const Text('Add new inventory item functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _requestRefill() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Refill'),
        content: const Text('Request refill functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _refreshInventory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inventory refreshed')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
