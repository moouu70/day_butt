import '../models/app_theme_preset.dart';
import 'aurora_theme.dart';
import 'deep_ocean_theme.dart';
import 'japan_theme.dart';
import 'midnight_theme.dart';
import 'night_forest_theme.dart';
import 'pure_minimal_theme.dart';
import 'sakura_night_theme.dart';
import 'samurai_night_theme.dart';
import 'sunset_theme.dart';

export 'aurora_theme.dart';
export 'deep_ocean_theme.dart';
export 'japan_theme.dart';
export 'midnight_theme.dart';
export 'night_forest_theme.dart';
export 'pure_minimal_theme.dart';
export 'sakura_night_theme.dart';
export 'samurai_night_theme.dart';
export 'sunset_theme.dart';

const List<AppThemePreset> kAppThemePresets = [
  midnightTheme,
  sakuraNightTheme,
  samuraiNightTheme,
  deepOceanTheme,
  nightForestTheme,
  sunsetTheme,
  pureMinimalTheme,
  auroraTheme,
];

AppThemePreset findPresetById(String id) {
  for (final preset in kAppThemePresets) {
    if (preset.id == id || (id == 'japan' && preset.id == 'samurai_night')) {
      return preset;
    }
  }
  return midnightTheme;
}
