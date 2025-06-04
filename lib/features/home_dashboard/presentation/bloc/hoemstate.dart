abstract class UserDataState {}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final String username;
  final String? userImageUrl;
  final String? userCategory;
  final String? userId;

  UserDataLoaded({
    required this.username,
    this.userImageUrl,
    this.userCategory,
    this.userId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserDataLoaded &&
        other.username == username &&
        other.userImageUrl == userImageUrl &&
        other.userCategory == userCategory &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return username.hashCode ^
    (userImageUrl?.hashCode ?? 0) ^
    (userCategory?.hashCode ?? 0) ^
    (userId?.hashCode ?? 0);
  }

  UserDataLoaded copyWith({
    String? username,
    String? userImageUrl,
    String? userCategory,
    String? userId,
  }) {
    return UserDataLoaded(
      username: username ?? this.username,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      userCategory: userCategory ?? this.userCategory,
      userId: userId ?? this.userId,
    );
  }
}

class UserDataError extends UserDataState {
  final String message;

  UserDataError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserDataError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
