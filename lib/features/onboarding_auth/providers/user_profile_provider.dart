// user_profile_provider.dart
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_up_screens/profile_set_up_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null);

  Future<void> setProfile(UserProfile profile) async {
    state = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', profile.uid);
    await prefs.setString('user_nickname', profile.nickname);
    await prefs.setInt('user_age', profile.age);
    await prefs.setString('user_location', profile.location);
    await prefs.setString('user_email', profile.email);
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('user_uid');
    final nickname = prefs.getString('user_nickname');
    final age = prefs.getInt('user_age');
    final location = prefs.getString('user_location');
    final email = prefs.getString('user_email');

    if (uid != null &&
        nickname != null &&
        age != null &&
        location != null &&
        email != null) {
      state = UserProfile(
        uid: uid,
        nickname: nickname,
        age: age,
        location: location,
        email: email,
      );
    }
  }

  Future<void> clearProfile() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
});
