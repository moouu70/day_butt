import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

const String kUserNameKey = 'user_name';

class UserNameNotifier extends Notifier<String> {
  @override
  String build() {
    _loadUserName();
    return AppConstants.fallbackUser;
  }

  Future<void> _loadUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString(kUserNameKey);
      if (savedName != null && savedName.trim().isNotEmpty) {
        state = savedName.trim();
      }
    } catch (_) {}
  }

  Future<void> setUserName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = trimmed;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kUserNameKey, trimmed);
    } catch (_) {}
  }
}

final userNameProvider = NotifierProvider<UserNameNotifier, String>(() {
  return UserNameNotifier();
});
