class User {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? phone;
  final String? role;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.phone,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  factory User.defaultUser() {
    return User(id: '', name: 'Usuario desconocido', email: 'Correo desconocido');
  }
}
