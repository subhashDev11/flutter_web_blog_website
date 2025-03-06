import 'package:flutter/material.dart';

import 'spacer.dart';

class RowSpacer extends StatelessWidget {
  /// This snippet shows O/P of [RowSpacer].
  ///
  /// ```dart
  /// I/P : [19, 21]
  /// O/P : [19, 7, 21]
  ///
  /// I/P : [19, 21, 23]
  /// O/P : [19, 7, 21, 7, 23]
  /// ```
  /// {@end-tool- $Subhash#Shukla$}
  const RowSpacer({
    super.key,
    required this.children,
    this.spacerWidget = const SpacerHorizontal(8),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment,
  }) : assert(
          children.length > 1,
          'children should be more than 1',
        );

  final List<Widget> children;

  final Widget spacerWidget;

  final CrossAxisAlignment crossAxisAlignment;

  final MainAxisSize mainAxisSize;

  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final List<Widget> spacedChildren = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      if (i == 0) {
        spacedChildren.add(children[i]);
      } else if (i == children.length - 1) {
        spacedChildren.add(spacerWidget);
        spacedChildren.add(children[i]);
      } else {
        spacedChildren.add(spacerWidget);
        spacedChildren.add(children[i]);
      }
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: spacedChildren,
    );
  }
}
