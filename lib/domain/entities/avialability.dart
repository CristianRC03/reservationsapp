class Avialability {
  final DateTime startDate;
  final DateTime endDate;

  Avialability({
    required this.startDate,
    required this.endDate,
  });

  factory Avialability.fromJson(Map<String, dynamic> json) {
    return Avialability(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }
}
