import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc_simple.dart';
import '../../../auth/presentation/widgets/owl_logo_widget.dart';
import '../../../auth/presentation/pages/auth_page.dart';
// import '../../../core/widgets/app_layout.dart';
// import '../../../core/config/animation_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Если пользователь не авторизован, показываем страницу аутентификации
        if (state is! AuthAuthenticatedState) {
          return const AuthPage();
        }

        // Если пользователь авторизован, показываем главную страницу
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
                const Text('Bukhindor'),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    context.read<AuthBloc>().add(AuthSignOutRequested());
                  } else if (value == 'version') {
                    context.go('/version');
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Text(
                            state.user.name.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                state.user.email,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'version',
                    child: Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 12),
                        Text('О приложении'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 12),
                        Text('Выйти'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 60,
                              height: 60,
                              child: OwlLogoWidget(
                                size: 60,
                                enableVersionAccess: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Добро пожаловать!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.user.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // User Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Информация о профиле',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: state.user.email,
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.person,
                          label: 'Имя',
                          value: state.user.name,
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.verified,
                          label: 'Email подтвержден',
                          value: state.user.emailVerified ? 'Да' : 'Нет',
                          valueColor: state.user.emailVerified
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.calendar_today,
                          label: 'Дата регистрации',
                          value: _formatDate(state.user.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Font Test Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Тест шрифта Comfortaa',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Light (300) - Легкий текст',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Regular (400) - Обычный текст',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Medium (500) - Средний текст',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SemiBold (600) - Полужирный текст',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bold (700) - Жирный текст',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Действия',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Implement profile edit
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Редактировать профиль'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: Implement settings
                                },
                                icon: const Icon(Icons.settings),
                                label: const Text('Настройки'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  context.go('/version');
                                },
                                icon: const Icon(Icons.info),
                                label: const Text('О приложении'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color:
                          valueColor ?? Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
