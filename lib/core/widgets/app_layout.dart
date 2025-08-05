import 'package:flutter/material.dart';
import 'beer_background_animation.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool enableBackgroundAnimation;

  const AppLayout({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.enableBackgroundAnimation = true,
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
      content = BeerBackgroundAnimation(
        enabled: true,
        child: content,
      );
    }

    return content;
  }
} 