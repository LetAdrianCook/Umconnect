class Users {
  final String id;
  final String name;
  final String email;
  final String image;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        image: json['image'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'image': image,
      };
}
