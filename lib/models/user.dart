// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FirebaseUser {
  final String email;
  final String name;
  final String  profilePicture;

  const FirebaseUser({
    required this.email,
    required this.name,
    required this.profilePicture,
  });

  FirebaseUser copyWith({
    String? email,
    String? name,
    String? profilePicture,
  }) {
    return FirebaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] as String,
      name: map['name'] as String,
      profilePicture: map['profilePicture'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FirebaseUser.fromJson(String source) => FirebaseUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FirebaseUser(email: $email, name: $name, profilePicture: $profilePicture)';

  @override
  bool operator ==(covariant FirebaseUser other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.name == name &&
      other.profilePicture == profilePicture;
  }

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ profilePicture.hashCode;
}

