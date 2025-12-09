import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class ApiService {
  // Ganti IP sesuai device: 10.0.2.2 (Emulator), 192.168.x.x (HP Fisik)
  final String _baseUrl = "http://10.158.94.18:8080";
  final String _tmApiKey = "KDZukG7dXSJPoEwQva06OhZChR0q0eBH";

  // --- 1. AUTHENTICATION ---

  Future<ApiResponse> register(
    String nama,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/registrasi"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nama': nama, 'email': email, 'password': password}),
      );

      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: "Register Error: $e");
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: "Login Error: $e");
    }
  }

  // --- 2. TICKETMASTER (EXTERNAL API) ---

  Future<ApiResponse> searchTicketmaster(String keyword) async {
    try {
      final url = Uri.parse(
        "https://app.ticketmaster.com/discovery/v2/events.json?keyword=$keyword&apikey=$_tmApiKey",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse(
          status: 200,
          message: "Success",
          data: data['_embedded']?['events'] ?? [],
        );
      } else {
        return ApiResponse(
          status: response.statusCode,
          message: "Failed to fetch events",
        );
      }
    } catch (e) {
      return ApiResponse(status: 500, message: "TM Error: $e");
    }
  }

  // --- 3. SCHEDULES (INTERNAL API) ---
  Future<ApiResponse> saveSchedule(
    int userId,
    Map<String, dynamic> event,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/schedules"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'external_id':
              event['id'] ?? 'CUSTOM-${DateTime.now().millisecondsSinceEpoch}',
          'event_name': event['name'],
          'event_date': event['dates']['start']['localDate'] + " 00:00:00",
          'venue_name': event['_embedded']['venues'][0]['name'],
          'image_url': '',
          'personal_notes': event['personalNotes'] ?? '-',
          'status': event['status'] ?? 'Plan',
        }),
      );

      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: e.toString());
    }
  }

  Future<ApiResponse> getSchedules(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/schedules?user_id=$userId"),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResponse(status: 200, message: "Success", data: json['data']);
      } else {
        return ApiResponse(
          status: response.statusCode,
          message: "Failed to fetch schedules",
        );
      }
    } catch (e) {
      return ApiResponse(status: 500, message: "Get Schedules Error: $e");
    }
  }

  Future<ApiResponse> updateSchedule(
    int id,
    String notes,
    String status,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/schedules/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'personal_notes': notes, 'status': status}),
      );

      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: "Update Schedule Error: $e");
    }
  }

  Future<ApiResponse> deleteSchedule(int id) async {
    try {
      final response = await http.delete(Uri.parse("$_baseUrl/schedules/$id"));
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: "Delete Schedule Error: $e");
    }
  }

  // --- 4. LOGOUT ---

  Future<ApiResponse> logout(int userId) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/logout"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      // Kalau server mati/error, tetap return sukses supaya bisa clear session lokal
      return ApiResponse(
        status: 200,
        message: "Force logout (server unreachable)",
      );
    }
  }
}
