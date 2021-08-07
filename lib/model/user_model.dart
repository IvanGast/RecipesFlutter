class UserModel {
  String email;
  String name;
  String uid;
  String pictureUrl;

  UserModel.fromMap(Map<String,dynamic> snapshot)
      : email = snapshot["email"],
        name = snapshot["name"],
        pictureUrl = snapshot["pictureUrl"],
        uid = snapshot["uid"];

      UserModel({this.email, this.name,  this.uid, this.pictureUrl});


  Map<String, String> toJson() => {
      "email": email,
      "name": name,
      "uid": uid,
      "pictureUrl": pictureUrl,
  };
}