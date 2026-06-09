import 'package:flutter/material.dart';
import 'package:my_app/components/profile_app_bar.dart';
import 'package:my_app/components/profile_details.dart';
import 'package:my_app/components/profile_header.dart';
import 'package:my_app/components/profile_tabs.dart';
import 'package:my_app/components/recipe_card.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.title});

  final String title;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int _selectedTab = 0;

  static const _recipes = [
    RecipeCardData(
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=700&fit=crop',
      title: 'Traditional spare ribs baked',
      chef: 'By Chef John',
      rating: 4.0,
      duration: '20 min',
    ),
    RecipeCardData(
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=700&fit=crop',
      title: 'Asian-style grilled chicken',
      chef: 'By Chef John',
      rating: 4.0,
      duration: '20 min',
    ),
    RecipeCardData(
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=700&fit=crop',
      title: 'Herb-roasted vegetable bowl',
      chef: 'By Chef John',
      rating: 4.0,
      duration: '20 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileHeader(),
                    const SizedBox(height: 16),
                    const ProfileDetails(),
                    const SizedBox(height: 20),
                    ProfileTabs(
                      selectedIndex: _selectedTab,
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTab = index;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ..._recipes.map(
                      (recipe) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: RecipeCard(
                          data: recipe,
                          onBookmarkTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
