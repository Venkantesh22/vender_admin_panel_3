import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class CustomDotttedLine extends StatelessWidget {
  const CustomDotttedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: DottedLine(
      dashColor: Colors.grey,
      lineThickness: 3,
      dashLength: 3,
      dashRadius: 80,
    ));
  }
}
