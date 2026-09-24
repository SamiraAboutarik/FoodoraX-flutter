import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}