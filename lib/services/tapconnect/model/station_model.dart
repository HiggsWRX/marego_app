class Station {
  final String id;
  final String name;
  final String zone;
  final double latitude;
  final double longitude;

  Station({
    required this.id,
    required this.name,
    required this.zone,
    required this.latitude,
    required this.longitude,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    // split by commas
    final splitName = json['name'].split(',');
    return Station(
      id: json['id'] as String,
      name: splitName[1] as String,
      zone: splitName[0] as String,
      latitude: json['lat'] as double,
      longitude: json['lon'] as double,
    );
  }
}
