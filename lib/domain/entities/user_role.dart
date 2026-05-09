/// Enum representing different user roles in UNIMARKET
enum UserRole {
  consumer('Universitario consumidor'),
  entrepreneur('Universitario emprendedor'),
  admin('Universitario administrador');

  final String displayName;

  const UserRole(this.displayName);

  /// Get a UserRole from a string value
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.consumer,
    );
  }

  /// Check if this role has admin permissions
  bool get isAdmin => this == UserRole.admin;

  /// Check if this role is an entrepreneur
  bool get isEntrepreneur => this == UserRole.entrepreneur;

  /// Check if this role can sell products
  bool get canSell => this == UserRole.entrepreneur || this == UserRole.admin;

  /// Check if this role is a consumer
  bool get isConsumer => this == UserRole.consumer;
}
