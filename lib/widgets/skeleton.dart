import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  final Widget child;

  const Shimmer({super.key, required this.child});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFFE6E6E6),
                Color(0xFFF7F7F7),
                Color(0xFFE6E6E6),
              ],
              stops: const [0.3, 0.5, 0.7],
              transform: _SlideTransform(-1 + 2 * _controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _SlideTransform extends GradientTransform {
  final double slidePercent;

  const _SlideTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class FoodCardSkeleton extends StatelessWidget {
  final double width;

  const FoodCardSkeleton({super.key, this.width = 180});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonBox(width: double.infinity, height: 125, radius: 16),
            SizedBox(height: 12),
            SkeletonBox(width: 110, height: 14, radius: 6),
            SizedBox(height: 8),
            SkeletonBox(width: 70, height: 12, radius: 6),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonBox(width: 60, height: 16, radius: 6),
                SkeletonBox(width: 32, height: 32, radius: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}