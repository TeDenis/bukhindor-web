import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class ReleaseNotesCard extends StatelessWidget {
  final String releaseNotes;

  const ReleaseNotesCard({
    super.key,
    required this.releaseNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.article,
                  color: Theme.of(context).colorScheme.primary,
                  size: AppConstants.iconSize,
                ),
                const SizedBox(width: 12),
                Text(
                  'Заметки о релизе',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                releaseNotes,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      fontFamily: 'monospace',
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
