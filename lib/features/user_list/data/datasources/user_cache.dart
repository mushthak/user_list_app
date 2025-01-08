import '../models/user_model.dart';

abstract class UserCache {
  Future<void> cacheUsers(List<UserModel> users);
  Future<List<UserModel>> getLastUsers();
  Future<void> clearCache();
}

class UserCacheImpl implements UserCache {
  List<UserModel> _cachedUsers = [];
  DateTime? _lastCacheTime;
  static const cacheValidDuration = Duration(minutes: 5);

  bool get isCacheValid {
    if (_lastCacheTime == null) return false;
    final difference = DateTime.now().difference(_lastCacheTime!);
    return difference < cacheValidDuration;
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    _cachedUsers = users;
    _lastCacheTime = DateTime.now();
  }

  @override
  Future<List<UserModel>> getLastUsers() async {
    if (!isCacheValid) {
      _cachedUsers.clear();
      _lastCacheTime = null;
    }
    return _cachedUsers;
  }

  @override
  Future<void> clearCache() async {
    _cachedUsers.clear();
    _lastCacheTime = null;
  }
}
