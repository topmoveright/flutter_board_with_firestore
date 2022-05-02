enum UserRole { admin, manager, user, guest }

class ModelUser {
  final int id;
  final UserRole role;
  final String name;
  final String? guestPassword;

  ModelUser({
    required this.id,
    required this.role,
    required this.name,
    this.guestPassword,
  });
}
