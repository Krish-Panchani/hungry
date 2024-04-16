class FoodBankData {
  final String Head;
  final String address;
  final String FoodNgoName;
  final String NumberOfPersons;
  final String location;
  final String phone;

  FoodBankData({
    required this.Head,
    required this.address,
    required this.FoodNgoName,
    required this.NumberOfPersons,
    required this.location,
    required this.phone,
  });

  factory FoodBankData.fromJson(Map<dynamic, dynamic> json) {
    return FoodBankData(
      Head: json['Head'] ?? '',
      address: json['address'] ?? '',
      FoodNgoName: json['FoodNgoName'] ?? '',
      NumberOfPersons: json['volunteers'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
