import 'package:shared_preferences/shared_preferences.dart';

class ThemeCachHelper {
  Future<void> cachThemeIndex(int themeIndex) async {
    final sharPreferences = await SharedPreferences.getInstance();
    sharPreferences.setInt("THEME_INDEX", themeIndex);
  }

  Future<int> getCachThemeIndex() async {
    final sharPreferences = await SharedPreferences.getInstance();
    final cachThemeIndex = sharPreferences.getInt("THEME_INDEX");
    if (cachThemeIndex != null) {
      return cachThemeIndex;
    } else {
      return 0;
    }
  }
}
