import 'package:flutter/material.dart';

/// Единый источник цветов приложения (production-стиль)
/// - Не используем хардкод цветов по виджетам
/// - Все базовые цвета централизованы здесь
class AppColors {
  AppColors._();

  // Базовые брендовые
  static const Color seed = Color(0xFFEA1D2C); // основной брендовый (красный)
  static const Color primary = Color(0xFFEA1D2C);
  static const Color onPrimary = Colors.white;

  // Нейтральные
  static const Color backgroundLight = Color(0xFFF8F9FB);
  static const Color backgroundDark = Color(0xFF0F1113);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1A1C1E);

  // Состояния
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFD32F2F);
}


