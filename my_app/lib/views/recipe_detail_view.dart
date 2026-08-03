import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/recipe_detail_controller.dart';
import '../models/recipe_model.dart';
import '../widgets/quantity_stepper.dart';

const _brandColor = Color(0xFF00BCD4);

class RecipeDetailView extends GetView<RecipeDetailController> {
  const RecipeDetailView({super.key});

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF3DAA6E);
      case 'medium':
        return const Color(0xFFE6A417);
      case 'hard':
        return const Color(0xFFE05252);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = controller.recipe;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 300,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CircleIconButton(
                icon: Icons.arrow_back,
                onTap: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Hero(
                tag: 'recipe-image-${recipe.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      recipe.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFF2F2F2),
                        child: const Icon(
                          Icons.restaurant_rounded,
                          size: 48,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.0),
                            Colors.black.withValues(alpha: 0.45),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _MetaRow(recipe: recipe, difficultyColor: _difficultyColor(recipe.difficulty)),
                  if (recipe.tags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recipe.tags.map((tag) => _TagChip(label: tag)).toList(),
                    ),
                  ],
                  const SizedBox(height: 22),
                  _StatsGrid(recipe: recipe),
                  if (recipe.ingredients.isNotEmpty) ...[
                    const SizedBox(height: 26),
                    const _SectionTitle(title: 'Ingredients'),
                    const SizedBox(height: 10),
                    ...recipe.ingredients.map((i) => _IngredientRow(text: i)),
                  ],
                  if (recipe.instructions.isNotEmpty) ...[
                    const SizedBox(height: 26),
                    const _SectionTitle(title: 'Instructions'),
                    const SizedBox(height: 10),
                    ...recipe.instructions.asMap().entries.map(
                          (e) => _StepRow(index: e.key + 1, text: e.value),
                        ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _AddToCartBar(recipe: recipe),
    );
  }
}

class _AddToCartBar extends GetView<RecipeDetailController> {
  final Recipe recipe;
  const _AddToCartBar({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Obx(
                () => QuantityStepper(
                  quantity: controller.quantity.value,
                  onIncrement: controller.increment,
                  onDecrement: controller.decrement,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Obx(
                    () => Text(
                      'Add to Cart · \$${(recipe.price * controller.quantity.value).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Recipe recipe;
  final Color difficultyColor;
  const _MetaRow({required this.recipe, required this.difficultyColor});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (recipe.rating > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 18),
              const SizedBox(width: 2),
              Text(
                '${recipe.rating.toStringAsFixed(1)} (${recipe.reviewCount})',
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        if (recipe.cuisine.isNotEmpty)
          Text(
            recipe.cuisine,
            style: const TextStyle(color: Color(0xFF9E9E9E), fontWeight: FontWeight.w500),
          ),
        if (recipe.difficulty.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: difficultyColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              recipe.difficulty,
              style: TextStyle(color: difficultyColor, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _brandColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _brandColor),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Recipe recipe;
  const _StatsGrid({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (Icons.timer_outlined, 'Time', recipe.totalTimeMinutes > 0 ? '${recipe.totalTimeMinutes} min' : '—'),
      (Icons.people_alt_outlined, 'Servings', '${recipe.servings}'),
      (
        Icons.local_fire_department_outlined,
        'Calories',
        recipe.caloriesPerServing > 0 ? '${recipe.caloriesPerServing} kcal' : '—',
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: _StatCard(icon: stats[i].$1, label: stats[i].$2, value: stats[i].$3),
          ),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: _brandColor, size: 22),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.black),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final String text;
  const _IngredientRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: _brandColor),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87))),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int index;
  final String text;
  const _StepRow({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: _brandColor, shape: BoxShape.circle),
            child: Text(
              '$index',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
