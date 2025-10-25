import 'dart:async';

// ignore: unused_import
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  int _currentIndex = 0;
  late Timer _timer;
  bool _isLeftPressed = false;
  bool _isRightPressed = false;

  final List<Map<String, String>> bannerItems = [
    {
      'title': 'Ev & Yaşam Ürünleri',
      'image':
          'https://ideacdn.net/idea/cl/50/myassets/products/662/9.jpg?revision=1750342153',
    },
    {
      'title': 'Elektronik Ürünler',
      'image':
          'https://www.androidauthority.com/wp-content/uploads/2023/10/Pixel-8-Pro-vs-iPhone-15-Pro-camera-shootout.jpg',
    },
    {
      'title': 'Giyim Ürünleri',
      'image':
          'https://www.meghantelpner.com/wp-content/uploads/2023/03/Plastics-in-Clothing.jpg',
    },
    {
      'title': 'Kitaplar',
      'image':
          'https://images.theconversation.com/files/45159/original/rptgtpxd-1396254731.jpg?ixlib=rb-4.1.0&q=45&auto=format&w=1356&h=668&fit=crop',
    },
    {
      'title': 'Spor & Outdoor',
      'image':
          'https://cdn.dsmcdn.com/mrktng/seo/22ekim15/outdoor-ne-demek-3.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (bannerItems.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % bannerItems.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (bannerItems.isEmpty) {
      return const Center(child: Text("Hiç banner yok 😢"));
    }

    // manual güvenli index
    int safeIndex = _currentIndex;
    if (safeIndex < 0) safeIndex = 0;
    if (safeIndex >= bannerItems.length) safeIndex = bannerItems.length - 1;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Container(
            width: double.infinity,
            key: ValueKey<int>(safeIndex),
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(bannerItems[safeIndex]['image']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                bannerItems[safeIndex]['title']!,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          left: 10,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isLeftPressed = true),
            onTapUp: (_) {
              setState(() => _isLeftPressed = false);
              _currentIndex =
                  (_currentIndex - 1 + bannerItems.length) % bannerItems.length;
            },
            onTapCancel: () => setState(() => _isLeftPressed = false),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _isLeftPressed ? 0.6 : 1.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 100),
                scale: _isLeftPressed ? 0.9 : 1.0,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          right: 10,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isRightPressed = true),
            onTapUp: (_) {
              setState(() => _isRightPressed = false);
              _currentIndex = (_currentIndex + 1) % bannerItems.length;
            },
            onTapCancel: () => setState(() => _isRightPressed = false),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _isRightPressed ? 0.6 : 1.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 100),
                scale: _isRightPressed ? 0.9 : 1.0,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 330,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bannerItems.length, (index) {
              bool isActive = index == safeIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: isActive ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
