import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final int completed;
  final int total;

  const CustomProgressIndicator({
    super.key,
    required this.progress,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'Progress: $completed / $total',
          style: TextStyle(
            color: theme.textTheme.bodyLarge!.color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            strokeWidth: 8,
          ),
        ),
      ],
    );
  }
}
