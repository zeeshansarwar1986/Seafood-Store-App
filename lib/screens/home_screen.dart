import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../theme/app_theme.dart';
import '../services/mock_api_service.dart';
import '../models/seafood_models.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockApiService _apiService = MockApiService();
  List<Category> _categories = [];
  List<SeafoodProduct> _featuredProducts = [];
  List<SeafoodProduct> _dailyDeals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await Future.wait([
      _apiService.getCategories(),
      _apiService.getFeaturedProducts(),
      _apiService.getDailyDeals(),
    ]);

    setState(() {
      _categories = data[0] as List<Category>;
      _featuredProducts = data[1] as List<SeafoodProduct>;
      _dailyDeals = data[2] as List<SeafoodProduct>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery to', style: Theme.of(context).textTheme.bodySmall),
            const Row(
              children: [
                Text('Home, Phase 8, DHA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Icon(Icons.keyboard_arrow_down, size: 16),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          Stack(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined)),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) => cart.totalItems > 0
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '${cart.totalItems}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeroSlider(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Categories', () {}),
                  _buildCategories(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Daily Deals', () {}),
                  _buildProductHorizontalList(_dailyDeals),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Featured Products', () {}),
                  _buildProductGrid(_featuredProducts),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildHeroSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.85,
      ),
      items: [
        'https://images.unsplash.com/photo-1590424753042-4914d334dd72?w=800', // Dungeness Crab
        'https://images.unsplash.com/photo-1553258219-565893ec1904?w=800', // Lobster
        'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=800', // Salmon
      ].map((url) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
              ),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: const Text(
              'Up to 30% Off\nOn Fresh Crabs!',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          TextButton(onPressed: onSeeAll, child: const Text('See All')),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Icon(Icons.set_meal, color: AppColors.primary, size: 30), // Svg placeholder
                ),
                const SizedBox(height: 8),
                Text(cat.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductHorizontalList(List<SeafoodProduct> products) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(product: products[index], isHorizontal: true),
      ),
    );
  }

  Widget _buildProductGrid(List<SeafoodProduct> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) => ProductCard(product: products[index]),
      ),
    );
  }
}
