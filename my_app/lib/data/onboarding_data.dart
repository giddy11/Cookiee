import 'package:flutter/material.dart';

class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

const List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    icon: Icons.restaurant_menu_rounded,
    title: 'Discover Recipes',
    description:
        'Explore thousands of recipes from cuisines around the world, all in one place.',
  ),
  OnboardingItem(
    icon: Icons.timer_outlined,
    title: 'Cook With Confidence',
    description:
        'See cook times and difficulty levels up front, so you always know what to expect.',
  ),
  OnboardingItem(
    icon: Icons.star_rounded,
    title: 'Rated By Real Cooks',
    description:
        'Check ratings and review counts from other home cooks before you start cooking.',
  ),
];
