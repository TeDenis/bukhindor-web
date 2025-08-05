import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Адаптивный виджет для отображения фоновой картинки
/// Автоматически подстраивается под разные размеры экрана
class AdaptiveSplashBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;
  final BoxFit fit;
  final Widget? fallback;

  const AdaptiveSplashBackground({
    super.key,
    required this.child,
    this.imagePath = 'assets/images/background.svg',
    this.fit = BoxFit.cover,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.of(context).size;
        final isSmallScreen = screenSize.width < 600;
        final isMediumScreen =
            screenSize.width >= 600 && screenSize.width < 1200;
        final isLargeScreen = screenSize.width >= 1200;

        return Stack(
          children: [
            // Адаптивная фоновая картинка
            Positioned.fill(
              child: _buildAdaptiveBackground(context, constraints, screenSize),
            ),

            // Основной контент
            child,
          ],
        );
      },
    );
  }

  Widget _buildAdaptiveBackground(
    BuildContext context,
    BoxConstraints constraints,
    Size screenSize,
  ) {
    // Для очень маленьких экранов используем более простой подход
    if (screenSize.width < 400) {
      return _buildSimpleBackground(context);
    }

    // Для средних и больших экранов используем SVG с адаптивным масштабированием
    return SvgPicture.asset(
      imagePath,
      fit: fit,
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      placeholderBuilder: (context) => _buildFallbackBackground(context),
    );
  }

  Widget _buildSimpleBackground(BuildContext context) {
    // Для очень маленьких экранов используем градиент
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackBackground(BuildContext context) {
    if (fallback != null) {
      return fallback!;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.05),
          ],
        ),
      ),
    );
  }
}

/// Адаптивный виджет для колеса загрузки
/// Автоматически подстраивается под размер экрана
class AdaptiveLoadingIndicator extends StatelessWidget {
  final String text;
  final double topOffset;
  final bool showBackground;

  const AdaptiveLoadingIndicator({
    super.key,
    this.text = 'Загрузка...',
    this.topOffset = 0.2,
    this.showBackground = true,
  });

    @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    // Адаптивные размеры
    final indicatorSize = isSmallScreen ? 50.0 : 60.0;
    final strokeWidth = isSmallScreen ? 3.0 : 4.0;
    final padding = isSmallScreen ? 16.0 : 24.0;
    final borderRadius = isSmallScreen ? 12.0 : 16.0;

    return Positioned(
      top: screenSize.height * topOffset,
      left: 0,
      right: 0,
      child: Center(
        child: showBackground
            ? Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _buildLoadingContent(
                  context,
                  indicatorSize,
                  strokeWidth,
                  isSmallScreen,
                ),
              )
            : _buildLoadingContent(
                context,
                indicatorSize,
                strokeWidth,
                isSmallScreen,
              ),
      ),
    );
  }

  Widget _buildLoadingContent(
    BuildContext context,
    double indicatorSize,
    double strokeWidth,
    bool isSmallScreen,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Колесо загрузки
        SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        // Текст загрузки
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: showBackground
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 14 : 16,
              ),
        ),
      ],
    );
  }
}
