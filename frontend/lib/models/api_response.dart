class ApiResponse {
  final int status; // Contoh: 200, 400, 201
  final String message; // Contoh: "Berhasil", "Gagal"
  final dynamic data; // Data fleksibel (bisa List atau Map)

  ApiResponse({required this.status, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'], // Pastikan backend kirim key 'status'
      message: json['message'] ?? '', // Pastikan backend kirim key 'message'
      data: json['data'], // Pastikan backend kirim key 'data'
    );
  }
}
