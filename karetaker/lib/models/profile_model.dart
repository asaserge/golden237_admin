class Profile {
  Profile({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
    required this.avatar,
    required this.phone,
    required this.email,
  });

  final String id;
  final String username;
  final DateTime updatedAt;
  final String avatar;
  final String phone;
  final String address;
  final String email;
  final DateTime createdAt;



  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        phone = map['phone'],
        email = map['email'],
        address = map['address'],
        avatar = map['address'],
        updatedAt = DateTime.parse(map['updatedAt']),
        createdAt = DateTime.parse(map['createdAt']);
}