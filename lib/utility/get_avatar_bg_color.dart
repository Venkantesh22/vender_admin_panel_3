import 'package:flutter/material.dart';

Color getAvatarBgColor(String? name) {
  if (name == null || name.isEmpty) return Colors.grey;

  // Get the first character and convert to uppercase
  String firstChar = name[0].toUpperCase();

  // Map A-Z to a list of distinct, visually appealing colors
  const List<Color> colors = [
    Color(0xFFEF5350), // A - Red
    Color(0xFFAB47BC), // B - Purple
    Color(0xFF5C6BC0), // C - Indigo
    Color(0xFF29B6F6), // D - Light Blue
    Color(0xFF26A69A), // E - Teal
    Color(0xFF66BB6A), // F - Green
    Color(0xFFFFCA28), // G - Amber
    Color(0xFFFF7043), // H - Deep Orange
    Color(0xFF8D6E63), // I - Brown
    Color(0xFF789262), // J - Olive
    Color(0xFF42A5F5), // K - Blue
    Color(0xFFD4E157), // L - Lime
    Color(0xFF7E57C2), // M - Deep Purple
    Color(0xFF26C6DA), // N - Cyan
    Color(0xFFFFA726), // O - Orange
    Color(0xFFA1887F), // P - Taupe
    Color(0xFFEC407A), // Q - Pink
    Color(0xFF66BB6A), // R - Green
    Color(0xFF26A69A), // S - Teal
    Color(0xFF5C6BC0), // T - Indigo
    Color(0xFFFFCA28), // U - Amber
    Color(0xFFAB47BC), // V - Purple
    Color(0xFF42A5F5), // W - Blue
    Color(0xFFEF5350), // X - Red
    Color(0xFFEC407A), // Y - Pink
    Color(0xFFFF7043), // Z - Deep Orange
  ];

  int index = firstChar.codeUnitAt(0) - 'A'.codeUnitAt(0);
  if (index < 0 || index >= colors.length) return Colors.grey;
  return colors[index];
}
