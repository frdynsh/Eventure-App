import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class SearchEventPage extends StatefulWidget {
  const SearchEventPage({super.key});

  @override
  State<SearchEventPage> createState() => _SearchEventPageState();
}

class _SearchEventPageState extends State<SearchEventPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  List<dynamic> _events = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIC SECTION ---

  void _doSearch() async {
    if (_searchController.text.isEmpty) return;

    FocusScope.of(context).unfocus(); // Tutup keyboard
    setState(() => _isLoading = true);

    try {
      final response = await _apiService.searchTicketmaster(
        _searchController.text,
      );

      if (response.status == 200 && response.data != null) {
        setState(() => _events = response.data as List<dynamic>);
      } else {
        setState(() => _events = []);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message.isNotEmpty
                  ? response.message
                  : "Tidak ada hasil ditemukan",
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _saveEvent(dynamic eventData) async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sesi habis, silakan login ulang"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await _apiService.saveSchedule(userId, eventData);

    if (!mounted) return;

    // Anggap status 200 sukses, selain itu gagal
    bool success = result.status == 200;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: success ? Colors.green : Colors.orange,
      ),
    );
  }

  // --- UI BUILD SECTION ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        title: Container(
          height: 45,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo.withOpacity(0.3)),
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: "Cari Artis / Kota...",
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.indigo),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _events = []);
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (val) => setState(() {}),
            onSubmitted: (_) => _doSearch(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: _doSearch,
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.indigo,
                size: 20,
              ),
              tooltip: "Cari",
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              color: Colors.indigo,
              minHeight: 3,
            ),
          _buildEventList(),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    if (!_isLoading && _events.isEmpty) {
      return Expanded(child: _buildEmptyState());
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _events.length,
        itemBuilder: (context, index) => _buildEventCard(_events[index]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 80,
              color: Colors.indigo.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              "Mulai Pencarian",
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Temukan konser favoritmu sekarang!",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(dynamic event) {
    String imgUrl = '';
    if (event['images'] != null && event['images'].isNotEmpty) {
      imgUrl = event['images'][0]['url'];
    }

    String date = event['dates']?['start']?['localDate'] ?? 'TBA';
    String venue =
        event['_embedded']?['venues']?[0]?['name'] ?? 'Unknown Venue';

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: imgUrl.isNotEmpty
                ? Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.indigo.withOpacity(0.1),
                    child: const Icon(
                      Icons.music_note,
                      size: 60,
                      color: Colors.indigo,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 16,
                            color: Colors.indigo,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.indigo,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              venue,
                              style: TextStyle(color: Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => _saveEvent(event),
                    icon: const Icon(Icons.bookmark_add_outlined),
                    color: Colors.indigo,
                    tooltip: "Simpan ke Jadwal",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
