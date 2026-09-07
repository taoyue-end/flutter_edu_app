import 'package:flutter/material.dart';

/// 品牌色板（对照安卓版 colors.xml）
class AppColors {
  /// 品牌橙（主色调）
  static const Color primary = Color(0xFFFF6E26);

  /// 价格红
  static const Color priceRed = Color(0xFFFE2C55);

  /// 主文字（深灰黑）
  static const Color textDark = Color(0xFF222222);

  /// 次级文字（灰）
  static const Color textGray = Color(0xFF999999);

  /// 页面背景
  static const Color bgLight = Color(0xFFF5F5F5);

  /// 卡片背景
  static const Color cardBg = Colors.white;

  /// 分割线
  static const Color divider = Color(0xFFEEEEEE);
}

/// 全局亮色主题
class AppTheme {
  static ThemeData get light => ThemeData(
        // 以品牌橙作为种子色，自动派生配色方案
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.bgLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textDark,
          elevation: 0.5,
          centerTitle: true,
        ),
        // 卡片样式：白底圆角（淘宝风商品卡的基础）
        cardTheme: CardThemeData(
          color: AppColors.cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgLight,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      );
}