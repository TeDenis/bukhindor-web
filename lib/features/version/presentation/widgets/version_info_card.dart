import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/constants/app_constants.dart';

class VersionInfoCard extends StatelessWidget {
  final PackageInfo? packageInfo;
  final String appVersion;
  final String buildNumber;
  final String buildDate;
  final String buildCommit;
  final String buildBranch;
  final String environment;

  const VersionInfoCard({
    super.key,
    this.packageInfo,
    required this.appVersion,
    required this.buildNumber,
    required this.buildDate,
    required this.buildCommit,
    required this.buildBranch,
    required this.environment,
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
                  Icons.info,
                  color: Theme.of(context).colorScheme.primary,
                  size: AppConstants.iconSize,
                ),
                const SizedBox(width: 12),
                Text(
                  'Информация о версии',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Версия приложения', appVersion),
            const SizedBox(height: 8),
            _buildInfoRow('Номер сборки', buildNumber),
            const SizedBox(height: 8),
            _buildInfoRow('Дата сборки', buildDate),
            const SizedBox(height: 8),
            _buildInfoRow('Коммит', buildCommit),
            const SizedBox(height: 8),
            _buildInfoRow('Ветка', buildBranch),
            const SizedBox(height: 8),
            _buildInfoRow('Окружение', environment),
            if (packageInfo != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Версия пакета', packageInfo!.version),
              const SizedBox(height: 8),
              _buildInfoRow('Номер пакета', packageInfo!.buildNumber),
              const SizedBox(height: 8),
              _buildInfoRow('Название пакета', packageInfo!.packageName),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Builder(
      builder: (context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
} 