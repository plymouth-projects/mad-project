import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';

class CarouselIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;
  final Color activeColor;
  final Color inactiveColor;
  final double activeDotWidth;
  final double dotHeight;
  final double dotWidth;
  final double spacing;
  
  const CarouselIndicator({
    Key? key,
    required this.itemCount,
    required this.currentPage,
    this.activeColor = AppColors.accentBlue,
    this.inactiveColor = const Color(0xFFD6D6D6), // A more consistent gray
    this.activeDotWidth = 24.0,
    this.dotHeight = 8.0,
    this.dotWidth = 8.0,
    this.spacing = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing),
          height: dotHeight,
          width: currentPage == index ? activeDotWidth : dotWidth,
          decoration: BoxDecoration(
            color: currentPage == index ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotHeight / 2),
          ),
        ),
      ),
    );
  }
}