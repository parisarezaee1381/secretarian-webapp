import 'package:flutter/material.dart';

class NestedRotatedRectangles extends StatelessWidget {
  const NestedRotatedRectangles({
    super.key,
    this.rotationDegrees = 45,
  });

  /// زاویه چرخش به درجه (پیش‌فرض همون ۴۵ درجه‌ی فیگما)
  final double rotationDegrees;

  static const List<_RectLayer> _layers = [
    _RectLayer(width: 1080, height: 384, color: Color(0xFFBBBBC0), hasShadow: true),
    _RectLayer(width: 952, height: 320, color: Color(0xFF828288)),
    _RectLayer(width: 824, height: 256, color: Color(0xFF101018)),
    _RectLayer(width: 696, height: 192, color: Color(0xFF3863A8)),
  ];

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotationDegrees * 3.1415926535 / 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final layer in _layers)
            Container(
              width: layer.width,
              height: layer.height,
              decoration: BoxDecoration(
                color: layer.color,
                boxShadow: layer.hasShadow
                    ? const [
                        BoxShadow(
                          color: Color(0x80000000), // #000000 با opacity 50%
                          offset: Offset(0, 8),
                          blurRadius: 24,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
            ),
        ],
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