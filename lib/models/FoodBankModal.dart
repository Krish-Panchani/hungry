class FoodBankData {
  final String Fname;
  final String address;
  final String details;
  final String location;
  final String phone;

  FoodBankData({
    required this.Fname,
    required this.address,
    required this.details,
    required this.location,
    required this.phone,
  });

  factory FoodBankData.fromJson(Map<dynamic, dynamic> json) {
    return FoodBankData(
      Fname: json['Fname'] ?? '',
      address: json['address'] ?? '',
      details: json['details'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
