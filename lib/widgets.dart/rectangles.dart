import 'dart:math' as math;

import 'package:flutter/material.dart';

class NestedRotatedRectangles extends StatelessWidget {
  const NestedRotatedRectangles({
    super.key,
    this.responsive = true,
    this.maxWidth = 1080,
    this.minWidth = 280,
  });

  final bool responsive;

  final double maxWidth;

  final double minWidth;

  static const List<_RectLayer> _layers = [
    _RectLayer(
      width: 1080,
      height: 384,
      color: Color(0xFFBBBBC0),
      hasShadow: true,
    ),
    _RectLayer(width: 952, height: 320, color: Color(0xFF828288)),
    _RectLayer(width: 824, height: 256, color: Color(0xFF101018)),
    _RectLayer(width: 696, height: 192, color: Color(0xFF3863A8)),
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
          // =========================================================
          // مکعب اول
          // سمت راست
          // 64 پیکسل از بالا
          // =========================================================

          Positioned(
            top: 64,
            right: -540 * scale,
            child: _buildCube(scale: scale, rotationDegrees: -45),
          ),

          // =========================================================
          // مکعب دوم
          // سمت چپ
          // دقیقاً زیر مکعب اول
          // =========================================================
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
                  color: const Color(0x80000000),
                  offset: Offset(0, 8 * scale),
                  blurRadius: 24 * scale,
                  spreadRadius: 0,
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
