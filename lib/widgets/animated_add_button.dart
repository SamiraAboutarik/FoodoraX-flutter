import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AnimatedAddButton extends StatefulWidget {
  final VoidCallback onTap;
  final double size;

  const AnimatedAddButton({
    super.key,
    required this.onTap,
    this.size = 32,
  });

  @override
  State<AnimatedAddButton> createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<AnimatedAddButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
  );

  late final Animation<double> _scale = Tween<double>(
    begin: 1.0,
    end: 0.8,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: widget.size * 0.6,
          ),
        ),
      ),
    );
  }
}