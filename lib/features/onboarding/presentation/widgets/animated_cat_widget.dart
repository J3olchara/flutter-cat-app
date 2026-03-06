import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_page.dart';

class AnimatedCatWidget extends StatefulWidget {
  final OnboardingPage page;
  final PageController pageController;
  final int pageIndex;

  const AnimatedCatWidget({
    super.key,
    required this.page,
    required this.pageController,
    required this.pageIndex,
  });

  @override
  State<AnimatedCatWidget> createState() => _AnimatedCatWidgetState();
}

class _AnimatedCatWidgetState extends State<AnimatedCatWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.page.emoji,
                    style: const TextStyle(fontSize: 120),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
