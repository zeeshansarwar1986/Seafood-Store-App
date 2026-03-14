import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/seafood_models.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final SeafoodProduct product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String _selectedWeight;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedWeight = widget.product.weightOptions[0];
  }

  double get _currentPrice {
    final basePrice = widget.product.discountPrice ?? widget.product.price;
    final multiplier = widget.product.weightMultipliers[_selectedWeight] ?? 1.0;
    return basePrice * multiplier * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.product.origin,
                          style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.product.rating} (${widget.product.reviewsCount} reviews)',
                        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      const Icon(Icons.timer_outlined, color: Colors.green, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        widget.product.freshnessInfo,
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Description', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  Text('Select Weight', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _buildWeightSelector(),
                  const SizedBox(height: 24),
                  _buildQuantitySelector(),
                  const SizedBox(height: 120), // Bottom padding for CTA
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomCTA(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.product.images[0],
          fit: BoxFit.cover,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightSelector() {
    return Wrap(
      spacing: 12,
      children: widget.product.weightOptions.map((weight) {
        final isSelected = _selectedWeight == weight;
        return ChoiceChip(
          label: Text(weight),
          selected: isSelected,
          onSelected: (selected) {
            setState(() => _selectedWeight = weight);
          },
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          showCheckmark: false,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
      }).toList(),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => setState(() => _quantity > 1 ? _quantity-- : null),
            icon: const Icon(Icons.remove),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$_quantity',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _quantity++),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Price', style: TextStyle(color: AppColors.textSecondary)),
              Text(
                '\$${_currentPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.read<CartProvider>().addItem(widget.product, _selectedWeight);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart!'), duration: Duration(seconds: 1)),
                );
              },
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
