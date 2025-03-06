import 'package:flutter/material.dart'
    show BoxDecoration, Color, DecoratedBox, Key, SizedBox;

class SpacerVertical extends SizedBox {
  const SpacerVertical({required double super.height, super.key});
}

class SpacerHorizontal extends SizedBox {
  const SpacerHorizontal(double width, {super.key}) : super(width: width);
}

class SpacerVerticalVisible extends DecoratedBox {
  SpacerVerticalVisible({super.key, double? height, Color? color})
      : super(
          decoration: BoxDecoration(color: color),
          child: SizedBox(
            height: height,
            width: double.maxFinite,
          ),
        );
}
