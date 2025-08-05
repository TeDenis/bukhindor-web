import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OwlLogoWidget extends StatefulWidget {
  final double size;
  final bool enableVersionAccess;

  const OwlLogoWidget({
    super.key,
    this.size = 100,
    this.enableVersionAccess = true,
  });

  @override
  State<OwlLogoWidget> createState() => _OwlLogoWidgetState();
}

class _OwlLogoWidgetState extends State<OwlLogoWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  int _clickCount = 0;
  DateTime? _lastClickTime;
  static const Duration _clickTimeout = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enableVersionAccess) return;

    final now = DateTime.now();
    
    // Сброс счетчика если прошло слишком много времени
    if (_lastClickTime != null && 
        now.difference(_lastClickTime!) > _clickTimeout) {
      _clickCount = 0;
    }

    _clickCount++;
    _lastClickTime = now;

    // Анимация при клике
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });

    // Проверка на 4 клика
    if (_clickCount >= 4) {
      _clickCount = 0;
      _showVersionAccessDialog();
    }
  }

  void _showVersionAccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.info,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Секретная функция'),
            ],
          ),
          content: const Text(
            'Открыть страницу с информацией о версии приложения?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/version');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Открыть'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _bounceAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value * _bounceAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(widget.size / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/owl_logo.svg',
                  width: widget.size * 0.6,
                  height: widget.size * 0.6,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 