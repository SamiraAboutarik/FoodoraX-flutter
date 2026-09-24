import 'package:flutter/material.dart';

class FadeInItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;

  const FadeInItem({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelay = const Duration(milliseconds: 60),
  });

  @override
  State<FadeInItem> createState() => _FadeInItemState();
}

class _FadeInItemState extends State<FadeInItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.08),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();

    Future.delayed(widget.baseDelay * widget.index, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}