import 'package:flutter/material.dart';

/// Единый источник цветов приложения (дружелюбная тема)
/// - Не используем хардкод цветов по виджетам
/// - Все базовые цвета централизованы здесь
/// -  палитра: желтые, зеленые, темно-голубые
class AppColors {
  AppColors._();


  static const Color seed = Color(0xFF004CFF); // основной брендовый (синий)
  static const Color primary = Color(0xFF004CFF); // синий
  static const Color primaryVariant = Color(0xFF3366FF); // светло-синий
  static const Color onPrimary = Colors.white;


  static const Color secondary = Color(0xFFFFC107); // желтый
  static const Color secondaryVariant = Color(0xFFFFD54F); // светло-желтый
  static const Color onSecondary = Color(0xFF212121); // темный текст на желтом

  // 🌊 Акцентные цвета
  static const Color accent = Color(0xFF1976D2); // темно-голубой
  static const Color accentVariant = Color(0xFF42A5F5); // голубой
  static const Color onAccent = Colors.white;


  static const Color backgroundLight = Color(0xFFF8FAFF); // очень светлый синеватый
  static const Color backgroundDark = Color(0xFF0A0F1A); // очень темный синеватый
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1A1F2A); // темный с синеватым оттенком


  static const Color success = Color(0xFF00C851); // яркий зеленый
  static const Color successLight = Color(0xFF66D9A3); // светло-зеленый
  static const Color warning = Color(0xFFFF9800); // оранжевый (теплый)
  static const Color warningLight = Color(0xFFFFB74D); // светло-оранжевый
  static const Color error = Color(0xFFE57373); // мягкий красный
  static const Color errorLight = Color(0xFFEF9A9A); // светло-красный


  static const Color info = Color(0xFF2196F3); // синий
  static const Color infoLight = Color(0xFF64B5F6); // светло-синий
  static const Color purple = Color(0xFF9C27B0); // фиолетовый
  static const Color purpleLight = Color(0xFFBA68C8); // светло-фиолетовый


  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x1AFFFFFF);
}


