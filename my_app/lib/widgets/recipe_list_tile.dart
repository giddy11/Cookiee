import 'package:flutter/material.dart';

import '../models/recipe_model.dart';

class RecipeListTile extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const RecipeListTile({super.key, required this.recipe, this.onTap});

  Color get _difficultyColor {
    switch (recipe.difficulty.toLowerCase()) {
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _RecipeListTileContent(
              recipe: recipe,
              difficultyColor: _difficultyColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipeListTileContent extends StatelessWidget {
  final Recipe recipe;
  final Color difficultyColor;

  const _RecipeListTileContent({
    required this.recipe,
    required this.difficultyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            recipe.image,
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                width: 96,
                height: 96,
                color: const Color(0xFFF2F2F2),
                child: const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF00BCD4),
                    ),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              width: 96,
              height: 96,
              color: const Color(0xFFF2F2F2),
              child: const Icon(
                Icons.restaurant_rounded,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.public_rounded,
                    size: 13,
                    color: Color(0xFF9E9E9E),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      recipe.cuisine,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ),
                  Text(
                    '#${recipe.id}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFC4C4C4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: difficultyColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      recipe.difficulty,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: difficultyColor,
                      ),
                    ),
                  ),
                  _MetaChip(
                    icon: Icons.timer_outlined,
                    label: '${recipe.cookTimeMinutes} min',
                  ),
                  _MetaChip(
                    icon: Icons.star_rounded,
                    iconColor: const Color(0xFFFFC107),
                    label:
                        '${recipe.rating.toStringAsFixed(1)} (${recipe.reviewCount})',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _MetaChip({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor ?? const Color(0xFF9E9E9E)),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF616161),
          ),
        ),
      ],
    );
  }
}
