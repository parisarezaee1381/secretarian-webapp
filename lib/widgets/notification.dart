import 'package:flutter/material.dart';
import 'buttons.dart';

import '../core/pending_letters_data.dart';
import 'package:flutter_application_1/core/theme.dart';

/// Today's pending-letters shortcut: a secondary button carrying the live
/// count, rendered only while at least one letter needs follow-up.
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
            color: AppColors.primary,
          ),
          onPressed: onPressed,
        );
      },
    );
  }
}
