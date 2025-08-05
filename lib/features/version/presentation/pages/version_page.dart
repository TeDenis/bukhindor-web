import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../widgets/version_info_card.dart';
import '../widgets/release_notes_card.dart';
import '../widgets/development_info_card.dart';

class VersionPage extends StatefulWidget {
  const VersionPage({super.key});

  @override
  State<VersionPage> createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  PackageInfo? _packageInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = packageInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset(
                'assets/icons/owl_logo.svg',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            const Text('О приложении'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          // Кнопка возврата на авторизацию
          IconButton(
            onPressed: () {
              context.go('/auth');
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.login,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            tooltip: 'Вернуться к авторизации',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Card(
                    elevation: AppConstants.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // App Logo
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF667eea),
                                  Color(0xFF764ba2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF667eea).withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // App Name
                          Text(
                            AppConstants.appName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 8),

                          // App Description
                          Text(
                            AppConstants.appDescription,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Version Info Card
                  VersionInfoCard(
                    packageInfo: _packageInfo,
                    appVersion: AppConstants.appVersion,
                    buildNumber: AppConstants.buildNumber,
                    buildDate: AppConstants.buildDate,
                    buildCommit: AppConstants.buildCommit,
                    buildBranch: AppConstants.buildBranch,
                    environment: AppConstants.environment,
                  ),
                  const SizedBox(height: 16),

                  // Release Notes Card
                  ReleaseNotesCard(
                    releaseNotes: AppConstants.releaseNotes,
                  ),
                  const SizedBox(height: 16),

                  // Development Info Card
                  DevelopmentInfoCard(
                    developerName: AppConstants.developerName,
                    developerEmail: AppConstants.developerEmail,
                    repositoryUrl: AppConstants.repositoryUrl,
                  ),
                  const SizedBox(height: 16),

                  // Technical Info Card
                  Card(
                    elevation: AppConstants.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.settings,
                                color: Theme.of(context).colorScheme.primary,
                                size: AppConstants.iconSize,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Техническая информация',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                              'API Base URL', AppConstants.apiBaseUrl),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                              'API Timeout', '${AppConstants.apiTimeout}ms'),
                          const SizedBox(height: 8),
                          _buildInfoRow('Animation Duration',
                              '${AppConstants.animationDuration}ms'),
                          const SizedBox(height: 8),
                          _buildInfoRow('Liquid Wave Speed',
                              AppConstants.liquidWaveSpeed.toString()),
                          const SizedBox(height: 8),
                          _buildInfoRow('Max Bubbles',
                              AppConstants.maxBubbles.toString()),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                              'Debug Mode',
                              AppConstants.isDebugMode
                                  ? 'Включен'
                                  : 'Выключен'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Back to Auth Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go('/auth');
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Вернуться к авторизации'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
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
                ),
          ),
        ),
      ],
    );
  }
}
