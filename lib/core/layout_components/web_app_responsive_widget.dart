import 'package:autoformsai_blogs/core/layout_components/responsive_widget.dart';
import 'package:flutter/material.dart';

class WepAppResponsiveWidget extends StatelessWidget {
  const WepAppResponsiveWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopView: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 900,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 40,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: child,
              ),
            ),
          ),
        ],
      ),
      mobileView: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: child,
      ),
    );
  }
}
