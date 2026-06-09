import 'package:flutter/material.dart';

class ProfileTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const ProfileTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const _tabLabels = ['Recipe', 'Videos', 'Tag'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          for (var index = 0; index < _tabLabels.length; index++) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: index == selectedIndex ? const Color(0xFF3DAA6E) : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color.fromRGBO(61, 170, 110, 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _tabLabels[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: index == selectedIndex ? Colors.white : const Color(0xFF3DAA6E),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (index < _tabLabels.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
