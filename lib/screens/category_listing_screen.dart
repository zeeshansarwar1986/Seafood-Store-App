import 'package:flutter/material.dart';
import '../models/seafood_models.dart';
import '../services/mock_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';

class CategoryListingScreen extends StatefulWidget {
  const CategoryListingScreen({super.key});

  @override
  State<CategoryListingScreen> createState() => _CategoryListingScreenState();
}

class _CategoryListingScreenState extends State<CategoryListingScreen> {
  final MockApiService _apiService = MockApiService();
  String _selectedCategoryId = '1';
  List<Category> _categories = [];
  List<SeafoodProduct> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final cats = await _apiService.getCategories();
    setState(() {
      _categories = cats;
    });
    _loadProductsForCategory(_selectedCategoryId);
  }

  Future<void> _loadProductsForCategory(String categoryId) async {
    setState(() => _isLoading = true);
    final products = await _apiService.getProductsByCategory(categoryId);
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Seafood', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar for Categories
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: AppColors.divider)),
            ),
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategoryId == cat.id;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategoryId = cat.id);
                    _loadProductsForCategory(cat.id);
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.background,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(cat.name),
                            size: 24,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Right Side for Product Grid
          Expanded(
            child: Container(
              color: AppColors.background,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _products.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) => ProductCard(product: _products[index]),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'fish': return Icons.set_meal;
      case 'prawns': return Icons.waves;
      case 'crabs': return Icons.brightness_high;
      case 'shellfish': return Icons.album;
      default: return Icons.restaurant;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text('No items found in this category', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
