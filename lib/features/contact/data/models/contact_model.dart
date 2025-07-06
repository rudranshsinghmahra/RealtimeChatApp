import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({
    required super.id,
    required super.username,
    required super.email,
    required super.profileImage,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['contact_id'],
      username: json['username'],
      email: json['email'],
      profileImage:
          json['profile_image'] ??
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
    );
  }
}
