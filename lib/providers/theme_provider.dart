import 'package:busic/providers/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 主题模式枚举
enum AppThemeMode { light, dark, system }

// 主题颜色枚举
enum AppThemeColor { deepPurple, blue, green, orange, pink, teal }

// 主题配置类
class ThemeConfig {
  final AppThemeMode themeMode;
  final AppThemeColor themeColor;

  const ThemeConfig({required this.themeMode, required this.themeColor});

  ThemeConfig copyWith({AppThemeMode? themeMode, AppThemeColor? themeColor}) {
    return ThemeConfig(
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}

// 主题配置Provider
class ThemeConfigNotifier extends Notifier<ThemeConfig> {
  static const String _themeModeKey = 'theme_mode';
  static const String _themeColorKey = 'theme_color';

  @override
  ThemeConfig build() {
    _loadThemeConfig();
    return const ThemeConfig(
      themeMode: AppThemeMode.system,
      themeColor: AppThemeColor.deepPurple,
    );
  }

  Future<void> _loadThemeConfig() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? 2; // 默认跟随系统
    final themeColorIndex = prefs.getInt(_themeColorKey) ?? 0; // 默认深紫色

    state = ThemeConfig(
      themeMode: AppThemeMode.values[themeModeIndex],
      themeColor: AppThemeColor.values[themeColorIndex],
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_themeModeKey, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setThemeColor(AppThemeColor color) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_themeColorKey, color.index);
    state = state.copyWith(themeColor: color);
  }

  // 获取主题模式对应的ThemeMode
  ThemeMode getThemeMode() {
    switch (state.themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  // 获取主题颜色
  Color getSeedColor() {
    switch (state.themeColor) {
      case AppThemeColor.deepPurple:
        return Colors.deepPurple;
      case AppThemeColor.blue:
        return Colors.blue;
      case AppThemeColor.green:
        return Colors.green;
      case AppThemeColor.orange:
        return Colors.orange;
      case AppThemeColor.pink:
        return Colors.pink;
      case AppThemeColor.teal:
        return Colors.teal;
    }
  }
}

final themeConfigProvider = NotifierProvider<ThemeConfigNotifier, ThemeConfig>(
  () => ThemeConfigNotifier(),
);

// 辅助方法：获取主题颜色名称
String getThemeColorName(AppThemeColor color) {
  switch (color) {
    case AppThemeColor.deepPurple:
      return '深紫色';
    case AppThemeColor.blue:
      return '蓝色';
    case AppThemeColor.green:
      return '绿色';
    case AppThemeColor.orange:
      return '橙色';
    case AppThemeColor.pink:
      return '粉色';
    case AppThemeColor.teal:
      return '青色';
  }
}

// 辅助方法：获取主题模式名称
String getThemeModeName(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return '浅色模式';
    case AppThemeMode.dark:
      return '深色模式';
    case AppThemeMode.system:
      return '跟随系统';
  }
}
