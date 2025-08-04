import 'package:flutter/material.dart';
import 'background_animation.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool enableBackgroundAnimation;
  final Color? waveColor;
  final Color? bubbleColor;
  final double waveOpacity;
  final double bubbleOpacity;

  const AppLayout({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.enableBackgroundAnimation = true,
    this.waveColor,
    this.bubbleColor,
    this.waveOpacity = 0.1,
    this.bubbleOpacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: child,
    );

    if (enableBackgroundAnimation) {
      content = BackgroundAnimation(
        waveColor: waveColor,
        bubbleColor: bubbleColor,
        waveOpacity: waveOpacity,
        bubbleOpacity: bubbleOpacity,
        child: content,
      );
    }

    return content;
  }
} 