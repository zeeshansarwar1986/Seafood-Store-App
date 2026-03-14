import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  final List<Map<String, String>> _slides = [
    {
      'image': 'https://images.unsplash.com/photo-1615141982883-c7ad0e69fd62?w=800', // Seafood Market
      'title': 'Fresh from the Sea',
      'desc': 'Directly sourced from local fishermen to your doorstep within hours.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=800', // Fresh Salmon
      'title': 'Premium Quality',
      'desc': 'Strict quality checks and certified freshness for every catch.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1553621542-f6e147245754?w=800', // Chef preparing fish
      'title': 'Same Day Delivery',
      'desc': 'Order now and get your seafood delivered fresh for dinner.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            items: _slides.map((slide) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    slide['image']!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slide['title']!,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          slide['desc']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            carouselController: _controller,
          ),
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _slides.asMap().entries.map((entry) {
                    return Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(
                          alpha: _currentIndex == entry.key ? 0.9 : 0.4,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Get Started'),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
