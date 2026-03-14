import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  final List<Map<String, dynamic>> _orders = const [
    {
      'id': 'SF-10294',
      'date': 'Oct 24, 2023',
      'total': 45.0,
      'status': 'In Preparation',
      'items': 3,
    },
    {
      'id': 'SF-09821',
      'date': 'Oct 20, 2023',
      'total': 32.5,
      'status': 'Delivered',
      'items': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return _buildOrderCard(context, order);
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final bool isInProgress = order['status'] != 'Delivered';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isInProgress ? AppColors.accent : Colors.green).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order['status'],
                  style: TextStyle(
                    color: isInProgress ? AppColors.accent : Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(order['date'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const Spacer(),
              const Icon(Icons.shopping_bag_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text('${order['items']} items', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${order['total'].toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
              ),
              ElevatedButton(
                onPressed: () => _showTracking(context, order),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Track Order', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTracking(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TrackingBottomSheet(order: order),
    );
  }
}

class _TrackingBottomSheet extends StatelessWidget {
  final Map<String, dynamic> order;
  const _TrackingBottomSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    const Text('Estimated Delivery: 20-30 mins', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=800'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.location_on, color: AppColors.primary, size: 30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTrackStep('Order Placed', 'Oct 24, 2023 - 10:30 AM', true, true),
                  _buildTrackStep('Payment Confirmed', 'Oct 24, 2023 - 10:32 AM', true, true),
                  _buildTrackStep('In Preparation', 'Oct 24, 2023 - 10:45 AM', true, false),
                  _buildTrackStep('Out for Delivery', 'Pending', false, false),
                  _buildTrackStep('Delivered', 'Pending', false, false, isLast: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackStep(String title, String time, bool isDone, bool isActive, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDone ? Colors.green : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(color: isActive ? Colors.green : Colors.transparent, width: 2),
              ),
              child: isDone ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: isDone ? Colors.green : Colors.grey[200]),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDone ? AppColors.textPrimary : AppColors.textSecondary)),
            Text(time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
