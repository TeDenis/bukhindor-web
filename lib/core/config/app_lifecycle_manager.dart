import 'package:flutter/material.dart';
import 'animation_config.dart';

class AppLifecycleManager extends StatefulWidget {
  final Widget child;
  
  const AppLifecycleManager({
    super.key,
    required this.child,
  });

  @override
  State<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final BeerAnimationManager _animationManager = BeerAnimationManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Инициализируем анимацию пива при запуске приложения
    _animationManager.initialize(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationManager.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        // Возобновляем анимацию при возвращении в приложение
        if (_animationManager.bubbleController != null) {
          _animationManager.bubbleController!.repeat();
        }
        if (_animationManager.foamController != null) {
          _animationManager.foamController!.repeat();
        }
        if (_animationManager.liquidController != null) {
          _animationManager.liquidController!.repeat();
        }
        break;
      case AppLifecycleState.paused:
        // Останавливаем анимацию при сворачивании приложения
        if (_animationManager.bubbleController != null) {
          _animationManager.bubbleController!.stop();
        }
        if (_animationManager.foamController != null) {
          _animationManager.foamController!.stop();
        }
        if (_animationManager.liquidController != null) {
          _animationManager.liquidController!.stop();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
} 