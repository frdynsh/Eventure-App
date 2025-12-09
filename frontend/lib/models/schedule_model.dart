class Schedule {
  final int? id;
  final int userId;
  // Bisa null karena event custom tidak punya external_id
  final String? externalId;
  final String eventName;
  final String eventDate;
  final String venueName;
  final String imageUrl;
  final String personalNotes;
  final String status;

  Schedule({
    this.id,
    required this.userId,
    this.externalId,
    required this.eventName,
    required this.eventDate,
    required this.venueName,
    required this.imageUrl,
    this.personalNotes = '',
    this.status = 'Plan',
  });

  /// Konversi dari JSON (response backend) ke Object Dart
  /// WAJIB tahan terhadap null & data custom
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      userId: int.parse(json['user_id'].toString()),
      externalId: json['external_id'], // bisa null → AMAN
      eventName: json['event_name'] ?? '-',
      eventDate: json['event_date'] ?? '1970-01-01',
      venueName: json['venue_name'] ?? '-',
      imageUrl: json['image_url'] ?? '',
      personalNotes: json['personal_notes'] ?? '',
      status: json['status'] ?? 'Plan',
    );
  }
}
