import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../screens/cart_tab.dart';
import '../screens/notifications_tab.dart';
import '../screens/settings_tab.dart';
import '../views/profile2_screen.dart';
import '../widgets/recipe_list_tile.dart';

const _brandColor = Color(0xFF00BCD4);

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentTabIndex.value,
          children: [
            const _RecipesTab(),
            const CartTab(),
            const Profile2Screen(),
            const NotificationsTab(),
            const SettingsTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Obx(
            () => BottomNavigationBar(
              currentIndex: controller.currentTabIndex.value,
              onTap: controller.changeTab,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: _brandColor,
              unselectedItemColor: const Color(0xFF9E9E9E),
              selectedFontSize: 11,
              unselectedFontSize: 11,
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  activeIcon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_none_outlined),
                  activeIcon: Icon(Icons.notifications),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipesTab extends GetView<HomeController> {
  const _RecipesTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Recipes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.black54),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: _brandColor),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return _StatusMessage(
              icon: Icons.wifi_off_rounded,
              title: 'Something went wrong',
              message: controller.errorMessage.value,
              actionLabel: 'Retry',
              onAction: controller.fetchRecipes,
            );
          }

          if (controller.recipes.isEmpty) {
            return _StatusMessage(
              icon: Icons.ramen_dining_outlined,
              title: 'No recipes found',
              message: 'Pull down to refresh and check again.',
              actionLabel: 'Refresh',
              onAction: controller.fetchRecipes,
            );
          }

          return RefreshIndicator(
            color: _brandColor,
            onRefresh: controller.fetchRecipes,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: controller.recipes.length,
              itemBuilder: (context, index) {
                final recipe = controller.recipes[index];
                return RecipeListTile(key: ValueKey(recipe.id), recipe: recipe);
              },
            ),
          );
        }),
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _StatusMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: const Color(0xFF9E9E9E)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
