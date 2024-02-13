class UserData {
  final String fname;
  final String address;
  final String details;
  final String location;
  final String phone;

  UserData({
    required this.fname,
    required this.address,
    required this.details,
    required this.location,
    required this.phone,
  });

  factory UserData.fromJson(Map<dynamic, dynamic> json) {
    return UserData(
      fname: json['Fname'] ?? '',
      address: json['address'] ?? '',
      details: json['details'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
