class UserModel {
  String id;
  String email;
  String name;
  String pictureUrl;

  UserModel({this.email, this.name, this.id, this.pictureUrl});

  UserModel.fromMap(Map<String, dynamic> snapshot, String id)
      : email = snapshot["email"],
        name = snapshot["name"],
        pictureUrl = snapshot["pictureUrl"],
        id = id;

  Map<String, String> toJson() => {
        "email": email,
        "name": name,
        "pictureUrl": pictureUrl,
      };
}
