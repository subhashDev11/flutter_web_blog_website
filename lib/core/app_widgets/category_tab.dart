import 'package:flutter/material.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key, required this.text, required this.selected});
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          decoration: selected ? TextDecoration.underline : TextDecoration.none,
          color: selected ? Colors.black : Colors.grey[700],
        ),
      ),
    );
  }
}
