class Schedule {
  final int? id;
  final int userId;
  final String externalId;
  final String eventName;
  final String eventDate;
  final String venueName;
  final String imageUrl;
  final String personalNotes;
  final String status;

  Schedule({
    this.id,
    required this.userId,
    required this.externalId,
    required this.eventName,
    required this.eventDate,
    required this.venueName,
    required this.imageUrl,
    this.personalNotes = '',
    this.status = 'Plan',
  });

  // Konversi dari JSON (Database) ke Object Dart
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      externalId: json['external_id'],
      eventName: json['event_name'],
      eventDate: json['event_date'],
      venueName: json['venue_name'],
      imageUrl: json['image_url'] ?? '',
      personalNotes: json['personal_notes'] ?? '',
      status: json['status'] ?? 'Plan',
    );
  }
}
