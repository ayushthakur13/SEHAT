import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class PharmacyDashboardScreen extends StatefulWidget {
  const PharmacyDashboardScreen({super.key});

  @override
  State<PharmacyDashboardScreen> createState() =>
      _PharmacyDashboardScreenState();
}

// Demo data models
class DemoPharmacy {
  final String name;
  final String license;
  final String location;
  final String phone;
  final bool isOpen;

  DemoPharmacy({
    required this.name,
    required this.license,
    required this.location,
    required this.phone,
    required this.isOpen,
  });
}

class DemoOrder {
  final String orderId;
  final String patientName;
  final String doctorName;
  final double total;
  final String status;
  final Color statusColor;
  final String date;
  final List<String> medicines;

  DemoOrder({
    required this.orderId,
    required this.patientName,
    required this.doctorName,
    required this.total,
    required this.status,
    required this.statusColor,
    required this.date,
    required this.medicines,
  });
}

class DemoMedicine {
  final String name;
  final String category;
  final int stockQuantity;
  final double price;
  final String expiryDate;
  final bool lowStock;

  DemoMedicine({
    required this.name,
    required this.category,
    required this.stockQuantity,
    required this.price,
    required this.expiryDate,
    required this.lowStock,
  });
}

class DemoStats {
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final double todayRevenue;

  DemoStats({
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.todayRevenue,
  });
}

class _PharmacyDashboardScreenState extends State<PharmacyDashboardScreen> {
  bool _isLoading = true;
  DemoPharmacy? _pharmacy;
  DemoStats? _stats;
  List<DemoOrder> _recentOrders = [];
  List<DemoMedicine> _lowStockMedicines = [];

  @override
  void initState() {
    super.initState();
    _loadDemoData();
  }

  Future<void> _loadDemoData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    // Demo pharmacy data
    _pharmacy = DemoPharmacy(
      name: 'HealthCare Pharmacy',
      license: 'PH-2025-001234',
      location: 'Downtown Medical Center',
      phone: '+1 234-567-8901',
      isOpen: true,
    );

    // Demo stats
    _stats = DemoStats(
      totalOrders: 24,
      pendingOrders: 8,
      completedOrders: 16,
      todayRevenue: 12500.0,
    );

    // Demo recent orders
    _recentOrders = [
      DemoOrder(
        orderId: 'ORD-1001',
        patientName: 'Emma Thompson',
        doctorName: 'Dr. Sarah Johnson',
        total: 450.0,
        status: 'Pending',
        statusColor: Colors.orange,
        date: '22 Sept 2025',
        medicines: ['Aspirin 75mg', 'Vitamin D3', 'Calcium'],
      ),
      DemoOrder(
        orderId: 'ORD-1002',
        patientName: 'John Smith',
        doctorName: 'Dr. Michael Chen',
        total: 320.0,
        status: 'Ready',
        statusColor: Colors.blue,
        date: '22 Sept 2025',
        medicines: ['Antibiotics', 'Pain reliever'],
      ),
      DemoOrder(
        orderId: 'ORD-1003',
        patientName: 'Lisa Anderson',
        doctorName: 'Dr. David Wilson',
        total: 280.0,
        status: 'Completed',
        statusColor: const Color(0xFF1976D2),
        date: '21 Sept 2025',
        medicines: ['Cough syrup', 'Throat lozenges'],
      ),
      DemoOrder(
        orderId: 'ORD-1004',
        patientName: 'Robert Davis',
        doctorName: 'Dr. Lisa Anderson',
        total: 520.0,
        status: 'Completed',
        statusColor: const Color(0xFF1976D2),
        date: '21 Sept 2025',
        medicines: ['Insulin', 'Blood glucose strips'],
      ),
    ];

    // Demo low stock medicines
    _lowStockMedicines = [
      DemoMedicine(
        name: 'Paracetamol 500mg',
        category: 'Pain Reliever',
        stockQuantity: 15,
        price: 25.0,
        expiryDate: '2026-08-15',
        lowStock: true,
      ),
      DemoMedicine(
        name: 'Amoxicillin 250mg',
        category: 'Antibiotic',
        stockQuantity: 8,
        price: 120.0,
        expiryDate: '2026-02-20',
        lowStock: true,
      ),
      DemoMedicine(
        name: 'Insulin Injection',
        category: 'Diabetes',
        stockQuantity: 5,
        price: 850.0,
        expiryDate: '2025-12-10',
        lowStock: true,
      ),
    ];

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        title: const Text('SEHAT - Pharmacy'),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  _showNotifications(context);
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  _showProfile(context);
                  break;
                case 'inventory':
                  _showInventory(context);
                  break;
                case 'settings':
                  _showSettings(context);
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.store_outlined),
                    SizedBox(width: 8),
                    Text('Pharmacy Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'inventory',
                child: Row(
                  children: [
                    Icon(Icons.inventory_outlined),
                    SizedBox(width: 8),
                    Text('Inventory'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddMedicine(context);
        },
        backgroundColor: const Color(0xFF1976D2),
        icon: const Icon(Icons.add),
        label: const Text('Add Medicine'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDemoData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildRecentOrders(),
            const SizedBox(height: 24),
            _buildLowStockAlert(),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.local_pharmacy,
                color: Color(0xFF1976D2),
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  Text(
                    _pharmacy?.name ?? 'Pharmacy',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1976D2),
                        ),
                  ),
                  Text(
                    _pharmacy?.location ?? 'Pharmacy Management',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (_pharmacy?.isOpen ?? false)
                    ? const Color(0xFF1976D2).withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (_pharmacy?.isOpen ?? false) ? 'Open' : 'Closed',
                style: TextStyle(
                  color: (_pharmacy?.isOpen ?? false)
                      ? const Color(0xFF1976D2)
                      : Colors.red[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Orders',
                '${_stats?.totalOrders ?? 0}',
                Icons.shopping_cart,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Pending',
                '${_stats?.pendingOrders ?? 0}',
                Icons.pending,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Completed',
                '${_stats?.completedOrders ?? 0}',
                Icons.check_circle,
                const Color(0xFF1976D2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Revenue',
                '₹${_stats?.todayRevenue.toStringAsFixed(0) ?? '0'}',
                Icons.currency_rupee,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'Prescriptions',
              Icons.receipt,
              Colors.blue,
              () {
                _showSnackBar('Opening prescriptions...');
              },
            ),
            _buildActionCard(
              'Inventory',
              Icons.inventory,
              const Color(0xFF1976D2),
              () {
                _showInventory(context);
              },
            ),
            _buildActionCard(
              'Orders',
              Icons.shopping_cart,
              Colors.orange,
              () {
                _showSnackBar('Opening orders...');
              },
            ),
            _buildActionCard(
              'Reports',
              Icons.analytics,
              Colors.purple,
              () {
                _showSnackBar('Opening reports...');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                _showSnackBar('Opening all orders...');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_recentOrders.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No recent orders',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentOrders.length > 4 ? 4 : _recentOrders.length,
            itemBuilder: (context, index) {
              final order = _recentOrders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: order.statusColor.withOpacity(0.1),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    order.orderId,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient: ${order.patientName}'),
                      Text('Doctor: ${order.doctorName}'),
                      Text('Total: ₹${order.total.toStringAsFixed(0)}'),
                      Text(order.date),
                    ],
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: order.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: order.statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onTap: () {
                    _showOrderDetails(order);
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildLowStockAlert() {
    if (_lowStockMedicines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[700], size: 20),
            const SizedBox(width: 8),
            Text(
              'Low Stock Alert',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _lowStockMedicines.length,
          itemBuilder: (context, index) {
            final medicine = _lowStockMedicines[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.orange[50],
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  child: const Icon(
                    Icons.medication,
                    color: Colors.orange,
                  ),
                ),
                title: Text(
                  medicine.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${medicine.category}'),
                    Text('Stock: ${medicine.stockQuantity} units'),
                    Text('Price: ₹${medicine.price.toStringAsFixed(0)}'),
                    Text('Expires: ${medicine.expiryDate}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    _showSnackBar('Reordering ${medicine.name}...');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text('Reorder'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1976D2),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.warning, color: Colors.orange),
              title: const Text('Low Stock Alert'),
              subtitle: const Text('3 medicines are running low'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.receipt, color: Colors.blue),
              title: const Text('New Prescription'),
              subtitle: const Text('Order #ORD-1005 received'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping, color: Color(0xFF1976D2)),
              title: const Text('Delivery Update'),
              subtitle: const Text('Stock delivery arriving tomorrow'),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pharmacy Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_pharmacy?.name}'),
            const SizedBox(height: 8),
            Text('License: ${_pharmacy?.license}'),
            const SizedBox(height: 8),
            Text('Location: ${_pharmacy?.location}'),
            const SizedBox(height: 8),
            Text('Phone: ${_pharmacy?.phone}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status: '),
                Icon(
                  (_pharmacy?.isOpen ?? false) ? Icons.check_circle : Icons.cancel,
                  color: (_pharmacy?.isOpen ?? false) ? const Color(0xFF1976D2) : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text((_pharmacy?.isOpen ?? false) ? 'Open' : 'Closed'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showInventory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inventory Management'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.medication, color: Colors.blue),
              title: Text('Total Medicines'),
              subtitle: Text('1,250 items'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.orange),
              title: Text('Low Stock Items'),
              subtitle: Text('15 items'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: Colors.red),
              title: Text('Expiring Soon'),
              subtitle: Text('8 items'),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Pharmacy Hours'),
              subtitle: Text('9:00 AM - 10:00 PM'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              subtitle: Text('Enabled'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Receipt Printer'),
              subtitle: Text('Connected'),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddMedicine(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medicine'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.add_circle, color: Colors.blue),
              title: Text('Manual Entry'),
              subtitle: Text('Add medicine manually'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.qr_code_scanner, color: Color(0xFF1976D2)),
              title: Text('Scan Barcode'),
              subtitle: Text('Scan medicine barcode'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.upload_file, color: Colors.orange),
              title: Text('Import CSV'),
              subtitle: Text('Bulk import medicines'),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Opening medicine entry form...');
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(DemoOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order ${order.orderId}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: ${order.patientName}'),
            const SizedBox(height: 8),
            Text('Doctor: ${order.doctorName}'),
            const SizedBox(height: 8),
            Text('Date: ${order.date}'),
            const SizedBox(height: 8),
            Text('Total: ₹${order.total.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status: '),
                Icon(Icons.circle, color: order.statusColor, size: 12),
                const SizedBox(width: 4),
                Text(order.status, style: TextStyle(color: order.statusColor)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Medicines:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...order.medicines.map((medicine) => Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text('• $medicine'),
            )),
          ],
        ),
        actions: [
          if (order.status == 'Pending')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar('Preparing order ${order.orderId}...');
              },
              child: const Text('Prepare'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
  }
}