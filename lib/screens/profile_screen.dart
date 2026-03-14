import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 18,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Zeeshan Khan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('zeeshan@example.com', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 30),
            _buildProfileItem(
              icon: Icons.shopping_bag_outlined,
              title: 'Order History',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen())),
            ),
            _buildProfileItem(
              icon: Icons.location_on_outlined,
              title: 'Saved Addresses',
              onTap: () {},
            ),
            _buildProfileItem(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              onTap: () {},
            ),
            _buildProfileItem(
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              onTap: () {},
            ),
            _buildProfileItem(
              icon: Icons.help_outline,
              title: 'Support',
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Divider(),
            ),
            _buildProfileItem(
              icon: Icons.logout,
              title: 'Logout',
              titleColor: Colors.red,
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: titleColor ?? AppColors.primary),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: titleColor ?? AppColors.textPrimary),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
