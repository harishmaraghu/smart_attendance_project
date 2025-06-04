class ProfileModel {
  final String name;
  final String userid;
  final String phonenumber;
  final String passportnumber;
  final String visanumber;
  final String imageUrl;

  ProfileModel({
    required this.name,
    required this.userid,
    required this.phonenumber,
    required this.passportnumber,
    required this.visanumber,
    required this.imageUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      userid: json['userid'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      passportnumber: json['passportnumber'] ?? '',
      visanumber: json['visanumber'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }}