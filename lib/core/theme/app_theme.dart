import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic colors that Material's [ColorScheme] does not provide
/// (success / warning / info / accent). Always read via `context.appColors`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color accent;
  final Color accentContainer;
  final Color onAccentContainer;

  const AppColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.accent,
    required this.accentContainer,
    required this.onAccentContainer,
  });

  static const light = AppColors(
    success: Color(0xFF1B8A4B),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFD4F5E0),
    onSuccessContainer: Color(0xFF0B3D20),
    warning: Color(0xFFC46A00),
    warningContainer: Color(0xFFFFE7C7),
    onWarningContainer: Color(0xFF4A2800),
    info: Color(0xFF1E66D0),
    infoContainer: Color(0xFFDCE8FF),
    onInfoContainer: Color(0xFF0A2A5C),
    accent: Color(0xFF7B4DD8),
    accentContainer: Color(0xFFEBDDFF),
    onAccentContainer: Color(0xFF2C1060),
  );

  static const dark = AppColors(
    success: Color(0xFF6FD99B),
    onSuccess: Color(0xFF00391C),
    successContainer: Color(0xFF14512F),
    onSuccessContainer: Color(0xFFC6F2D6),
    warning: Color(0xFFFFB866),
    warningContainer: Color(0xFF5C3600),
    onWarningContainer: Color(0xFFFFE2BF),
    info: Color(0xFF9CC2FF),
    infoContainer: Color(0xFF16407D),
    onInfoContainer: Color(0xFFD8E5FF),
    accent: Color(0xFFCFB5FF),
    accentContainer: Color(0xFF4A2A8C),
    onAccentContainer: Color(0xFFEBDDFF),
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      success: l(success, other.success),
      onSuccess: l(onSuccess, other.onSuccess),
      successContainer: l(successContainer, other.successContainer),
      onSuccessContainer: l(onSuccessContainer, other.onSuccessContainer),
      warning: l(warning, other.warning),
      warningContainer: l(warningContainer, other.warningContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      info: l(info, other.info),
      infoContainer: l(infoContainer, other.infoContainer),
      onInfoContainer: l(onInfoContainer, other.onInfoContainer),
      accent: l(accent, other.accent),
      accentContainer: l(accentContainer, other.accentContainer),
      onAccentContainer: l(onAccentContainer, other.onAccentContainer),
    );
  }
}

/// Shorthand accessors: `context.cs`, `context.appColors`, `context.tt`.
extension ThemeX on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
  TextTheme get tt => Theme.of(this).textTheme;
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

class AppTheme {
  AppTheme._();

  static const Color seed = Color(0xFF3D5AFE);

  static ThemeData light() => _build(
        ColorScheme.fromSeed(seedColor: seed),
      );

  static ThemeData dark() => _build(
        ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
      );

  static ThemeData _build(ColorScheme cs) {
    final isDark = cs.brightness == Brightness.dark;
    final base = ThemeData(useMaterial3: true, colorScheme: cs);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: cs.onSurface,
      displayColor: cs.onSurface,
    );

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: cs.surface,
      extensions: [isDark ? AppColors.dark : AppColors.light],
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      dividerTheme: DividerThemeData(color: cs.outlineVariant, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: isDark ? 0.5 : 0.6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surfaceContainerLow,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surfaceContainer,
        indicatorColor: cs.secondaryContainer,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
      ),
    );
  }
}
