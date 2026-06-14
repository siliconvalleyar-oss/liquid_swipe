import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A reusable glassmorphism container widget.
/// Uses BackdropFilter with ImageFilter.blur and semi-transparent colors
/// to create the frosted glass effect.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<Color>? gradientColors;
  final List<double>? gradientStops;
  final List<Color>? borderGradientColors;
  final Alignment begin;
  final Alignment end;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.blur = 15,
    this.borderWidth = 1.5,
    this.padding,
    this.margin,
    this.gradientColors,
    this.gradientStops,
    this.borderGradientColors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> bgColors = gradientColors ??
        [
          Colors.white.withValues(alpha: 0.15),
          Colors.white.withValues(alpha: 0.05),
        ];

    final List<Color> bdrColors = borderGradientColors ??
        [
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.1),
        ];

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: bdrColors,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - borderWidth),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(borderRadius - borderWidth),
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: bgColors,
                stops: gradientStops,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A simple glass effect button.
class GlassButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final double borderRadius;
  final double blur;

  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.borderRadius = 16,
    this.blur = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.15),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius - 1),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
