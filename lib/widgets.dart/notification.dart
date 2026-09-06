import 'package:flutter/material.dart';
import 'buttons.dart';

class PendingLettersData {
  PendingLettersData._();

  static final ValueNotifier<int> count = ValueNotifier<int>(0);
}

class PendingLettersButton extends StatelessWidget {
  const PendingLettersButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: PendingLettersData.count,
      builder: (context, count, _) {
        if (count == 0) {
          return const SizedBox.shrink();
        }

        return CustomButton(
          label: '$count نامه نیازمند پیگیری برای امروز',
          type: ButtonType.secondary,
          width: 336,
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: Color(0xFF3863A8),
          ),
          onPressed: onPressed,
        );
      },
    );
  }
}
