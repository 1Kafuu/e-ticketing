enum UserRole {
  admin,
  helpdesk,
  user;

  // Helper untuk mengubah string dari SharedPreferences menjadi Enum
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role.toLowerCase(),
      orElse: () => UserRole.user,
    );
  }
}