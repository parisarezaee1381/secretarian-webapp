import 'package:flutter/material.dart';

class FakoorLoginCard extends StatelessWidget {
  final Widget? child;

  const FakoorLoginCard({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 808,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F7).withValues(alpha: 0.9),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 64,
          bottom: 64,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 64,
            ),

            const SizedBox(height: 32),

            // Title
            const Text(
              'سیستم دبیرخانه فکور',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Estedad-VF',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF101018),
              ),
            ),

            // Content
            if (child != null) ...[
              const SizedBox(height: 64),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}