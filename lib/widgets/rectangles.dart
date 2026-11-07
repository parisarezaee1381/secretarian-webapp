import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme.dart';

/// Decorative background for the auth screens: two -45° "cubes" of four
/// nested rectangles each, drawn half off-canvas at the left and right
/// edges.
///
/// Horizontal offsets and the shadow scale with the available width;
/// vertical anchors (`top`, `height`) stay fixed, which only shifts the
/// decorative composition at extreme aspect ratios.
class NestedRotatedRectangles extends StatelessWidget {
  const NestedRotatedRectangles({
    super.key,
    this.responsive = true,
    this.maxWidth = 1080,
    this.minWidth = 280,
  });

  final bool responsive;

  /// Design width at full scale, and the ceiling the available width is
  /// clamped to before scaling. Must match the widest layer below (1080),
  /// or the cubes render at the wrong size.
  final double maxWidth;

  final double minWidth;

  static const List<_RectLayer> _layers = [
    _RectLayer(
      width: 1080,
      height: 384,
      color: AppColors.border,
      hasShadow: true,
    ),
    _RectLayer(width: 952, height: 320, color: AppColors.mutedText),
    _RectLayer(width: 824, height: 256, color: AppColors.text),
    _RectLayer(width: 696, height: 192, color: AppColors.primary),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double scale = 1;

        if (responsive && constraints.maxWidth.isFinite) {
          final availableWidth = constraints.maxWidth;

          final targetWidth = availableWidth.clamp(minWidth, maxWidth);

          scale = targetWidth / maxWidth;
        }

        return _buildTwoCubes(scale: scale);
      },
    );
  }

  Widget _buildTwoCubes({required double scale}) {
    return SizedBox(
      width: double.infinity,
      height: 850,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: 64,
            right: -540 * scale,
            child: _buildCube(scale: scale, rotationDegrees: -45),
          ),

          Positioned(
            top: 448,
            left: -540 * scale,
            child: _buildCube(scale: scale, rotationDegrees: -45),
          ),
        ],
      ),
    );
  }

  Widget _buildCube({required double scale, required double rotationDegrees}) {
    final angle = rotationDegrees * math.pi / 180;

    return Transform.rotate(
      angle: angle,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          for (final layer in _layers) _buildLayer(layer: layer, scale: scale),
        ],
      ),
    );
  }

  Widget _buildLayer({required _RectLayer layer, required double scale}) {
    final width = layer.width * scale;
    final height = layer.height * scale;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: layer.color,
        boxShadow: layer.hasShadow
            ? [
                BoxShadow(
                  color: AppColors.shadowStrong,
                  offset: Offset(0, 8 * scale),
                  blurRadius: 24 * scale,
                ),
              ]
            : null,
      ),
    );
  }
}

class _RectLayer {
  const _RectLayer({
    required this.width,
    required this.height,
    required this.color,
    this.hasShadow = false,
  });

  final double width;
  final double height;
  final Color color;
  final bool hasShadow;
}
