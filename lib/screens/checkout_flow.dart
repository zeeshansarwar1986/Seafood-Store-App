import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'order_confirmation_screen.dart';

class CheckoutFlow extends StatefulWidget {
  const CheckoutFlow({super.key});

  @override
  State<CheckoutFlow> createState() => _CheckoutFlowState();
}

class _CheckoutFlowState extends State<CheckoutFlow> {
  int _currentStep = 0;
  int _selectedDateIndex = 0;
  String _selectedTimeSlot = '09:00 AM - 12:00 PM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _placeOrder();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 2 ? 'Place Order' : 'Continue'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Address'),
            isActive: _currentStep >= 0,
            content: _buildAddressSection(),
          ),
          Step(
            title: const Text('Slot'),
            isActive: _currentStep >= 1,
            content: _buildSlotSection(),
          ),
          Step(
            title: const Text('Payment'),
            isActive: _currentStep >= 2,
            content: _buildPaymentSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      children: [
        _buildSelectionCard(
          icon: Icons.home_outlined,
          title: 'Home',
          subtitle: 'Phase 8, DHA, Karachi, PK',
          isSelected: true,
        ),
        const SizedBox(height: 12),
        _buildSelectionCard(
          icon: Icons.work_outline,
          title: 'Office',
          subtitle: 'Sector 5, I.I Chundrigar Road',
          isSelected: false,
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add New Address'),
        ),
      ],
    );
  }

  Widget _buildSlotSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Delivery Date', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(5, (index) {
              final date = DateTime.now().add(Duration(days: index));
              return _buildDateCard(date, index, _selectedDateIndex == index);
            }),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Time Slot', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildTimeChip('09:00 AM - 12:00 PM', _selectedTimeSlot == '09:00 AM - 12:00 PM'),
            _buildTimeChip('12:00 PM - 03:00 PM', _selectedTimeSlot == '12:00 PM - 03:00 PM'),
            _buildTimeChip('03:00 PM - 06:00 PM', _selectedTimeSlot == '03:00 PM - 06:00 PM'),
            _buildTimeChip('06:00 PM - 09:00 PM', _selectedTimeSlot == '06:00 PM - 09:00 PM'),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      children: [
        _buildSelectionCard(
          icon: Icons.money_outlined,
          title: 'Cash on Delivery',
          subtitle: 'Pay when you receive the order',
          isSelected: true,
        ),
        const SizedBox(height: 12),
        _buildSelectionCard(
          icon: Icons.credit_card_outlined,
          title: 'Credit / Debit Card',
          subtitle: '**** **** **** 4242',
          isSelected: false,
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.divider,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildDateCard(DateTime date, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedDateIndex = index),
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
        ),
        child: Column(
          children: [
            Text(
              _getWeekDay(date.weekday),
              style: TextStyle(color: isSelected ? Colors.white70 : AppColors.textSecondary, fontSize: 12),
            ),
            Text(
              '${date.day}',
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeSlot = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _getWeekDay(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }

  void _placeOrder() {
    context.read<CartProvider>().clearCart();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OrderConfirmationScreen()),
    );
  }
}
