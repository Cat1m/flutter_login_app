class User {
  final String? username;
  final String? appVer;
  final String? token;
  final String? deviceId;

  User({
    required this.username,
    required this.appVer,
    required this.token,
    required this.deviceId,
  });

  factory User.fromMap(Map<String, Object?> map) {
    return User(
      username: map['username'] as String?,
      appVer: map['appver'] as String?,
      token: map['token'] as String?,
      deviceId: map['deviceid'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'username': username,
      'appver': appVer,
      'token': token,
      'deviceid': deviceId,
    };
  }

  @override
  String toString() {
    return 'User{username: $username, appVer: $appVer, token: $token, deviceId: $deviceId}';
  }
}
