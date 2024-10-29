class Esp {
  final String espNumber;
  final String ipAddress;
  final String lat;
  final String long;
  bool state;

  Esp({required this.espNumber, required this.ipAddress, this.state = false, required this.lat, required this.long});

  factory Esp.fromJson(Map<String, dynamic> json) {
    return Esp(
      espNumber: json['espnumber'] ?? '',
      ipAddress: json['ipaddress'] ?? '',
      lat: json['latitude'] ?? '',
      long: json['longitude'] ?? '',
      state: json['state'] == 'ON',
    );
  }
}
