import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Emergency', 'Medicine', 'Lab Results', 'Appointments'];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'N001',
      'title': 'Emergency Patient Arrival',
      'message': 'Patient P003 (Mike Johnson) has arrived with chest pain. Priority: High',
      'type': 'Emergency',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
      'priority': 'High',
    },
    {
      'id': 'N002',
      'title': 'Medicine Shortage Alert',
      'message': 'Ibuprofen stock is running low (15 tablets remaining). Minimum stock: 20',
      'type': 'Medicine',
      'time': DateTime.now().subtract(const Duration(minutes: 30)),
      'isRead': false,
      'priority': 'Medium',
    },
    {
      'id': 'N003',
      'title': 'Lab Test Results Ready',
      'message': 'Blood test results for Patient P001 (John Doe) are now available',
      'type': 'Lab Results',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'isRead': true,
      'priority': 'Low',
    },
    {
      'id': 'N004',
      'title': 'Appointment Reminder',
      'message': 'You have an appointment with Patient P002 (Jane Smith) in 15 minutes',
      'type': 'Appointments',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
      'priority': 'Medium',
    },
    {
      'id': 'N005',
      'title': 'Shift Reminder',
      'message': 'Your shift ends in 2 hours. Please complete pending consultations',
      'type': 'Appointments',
      'time': DateTime.now().subtract(const Duration(hours: 3)),
      'isRead': true,
      'priority': 'Low',
    },
    {
      'id': 'N006',
      'title': 'Oxygen Cylinder Low',
      'message': 'Oxygen cylinder stock is running low (8 cylinders remaining). Minimum: 5',
      'type': 'Medicine',
      'time': DateTime.now().subtract(const Duration(hours: 4)),
      'isRead': false,
      'priority': 'High',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: _markAllAsRead,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openNotificationSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF1976D2),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshNotifications,
                ),
              ],
            ),
          ),
          
          // Notification Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total', '${_getFilteredNotifications().length}', Icons.notifications, Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Unread', '${_getUnreadCount()}', Icons.mark_email_unread, Colors.red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Emergency', '${_getEmergencyCount()}', Icons.emergency, Colors.orange),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Notifications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _getFilteredNotifications().length,
              itemBuilder: (context, index) {
                final notification = _getFilteredNotifications()[index];
                return _buildNotificationCard(notification);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredNotifications() {
    List<Map<String, dynamic>> filtered = _notifications;

    // Apply filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((notification) => notification['type'] == _selectedFilter).toList();
    }

    // Sort by time (newest first)
    filtered.sort((a, b) => b['time'].compareTo(a['time']));

    return filtered;
  }

  int _getUnreadCount() {
    return _notifications.where((notification) => !notification['isRead']).length;
  }

  int _getEmergencyCount() {
    return _notifications.where((notification) => notification['type'] == 'Emergency').length;
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

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final priorityColor = _getPriorityColor(notification['priority']);
    final typeIcon = _getTypeIcon(notification['type']);
    final timeAgo = _getTimeAgo(notification['time']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _viewNotificationDetails(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      typeIcon,
                      color: priorityColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'],
                                style: TextStyle(
                                  fontWeight: notification['isRead'] ? FontWeight.w500 : FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (!notification['isRead'])
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notification['priority'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notification['message'],
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _markAsRead(notification),
                      icon: const Icon(Icons.mark_email_read, size: 16),
                      label: const Text('Mark Read'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _takeAction(notification),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Take Action'),
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Emergency':
        return Icons.emergency;
      case 'Medicine':
        return Icons.medication;
      case 'Lab Results':
        return Icons.science;
      case 'Appointments':
        return Icons.calendar_today;
      default:
        return Icons.notifications;
    }
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, h:mm a').format(time);
    }
  }

  void _viewNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['message']),
            const SizedBox(height: 16),
            Text(
              'Type: ${notification['type']}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Priority: ${notification['priority']}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Time: ${DateFormat('MMM d, y h:mm a').format(notification['time'])}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
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

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification marked as read')),
    );
  }

  void _takeAction(Map<String, dynamic> notification) {
    String action = '';
    
    switch (notification['type']) {
      case 'Emergency':
        action = 'Navigate to emergency patient';
        break;
      case 'Medicine':
        action = 'Check inventory and request refill';
        break;
      case 'Lab Results':
        action = 'View lab results';
        break;
      case 'Appointments':
        action = 'View appointment details';
        break;
      default:
        action = 'Handle notification';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Take Action'),
        content: Text('Action: $action'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _markAsRead(notification);
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _openNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: const Text('Notification settings functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _refreshNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications refreshed')),
    );
  }
}
