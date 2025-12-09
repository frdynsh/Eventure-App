import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/schedule_model.dart';
import '../models/api_response.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Schedule>> _futureSchedules;
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId') ?? 0;

    setState(() {
      _userId = id;
      _futureSchedules = _fetchSchedules();
    });
  }

  Future<List<Schedule>> _fetchSchedules() async {
    ApiResponse response = await _apiService.getSchedules(_userId);
    if (response.status == 200 && response.data != null) {
      return (response.data as List)
          .map((x) => Schedule.fromJson(Map<String, dynamic>.from(x)))
          .toList();
    }
    return [];
  }

  void _deleteItem(int id) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Hapus Jadwal?"),
            content: const Text("Data akan hilang permanen."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      await _apiService.deleteSchedule(id);
      _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Jadwal dihapus")));
    }
  }

  void _editItem(Schedule item) {
    final noteCtrl = TextEditingController(text: item.personalNotes);
    String currentStatus = item.status;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Edit Jadwal"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: noteCtrl,
                  decoration: const InputDecoration(
                    labelText: "Catatan Pribadi",
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: currentStatus,
                  items: ['Plan', 'Going', 'Done']
                      .map(
                        (val) => DropdownMenuItem(value: val, child: Text(val)),
                      )
                      .toList(),
                  onChanged: (newValue) =>
                      setStateDialog(() => currentStatus = newValue!),
                  decoration: const InputDecoration(
                    labelText: "Status Kehadiran",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _apiService.updateSchedule(
                    item.id!,
                    noteCtrl.text,
                    currentStatus,
                  );
                  Navigator.pop(context);
                  _loadData();
                },
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addCustomSchedule() {
    final nameCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final venueCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Jadwal Sendiri"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Nama Event"),
              ),
              TextField(
                controller: dateCtrl,
                decoration: const InputDecoration(
                  labelText: "Tanggal (YYYY-MM-DD)",
                ),
              ),
              TextField(
                controller: venueCtrl,
                decoration: const InputDecoration(labelText: "Tempat"),
              ),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: "Catatan Pribadi"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_userId == 0) return;

              final response = await _apiService.saveSchedule(_userId, {
                "name": nameCtrl.text,
                "dates": {
                  "start": {"localDate": dateCtrl.text},
                },
                "_embedded": {
                  "venues": [
                    {"name": venueCtrl.text},
                  ],
                },
                "images": [],
                "personalNotes": noteCtrl.text,
                "status": "Plan",
              });

              if (!mounted) return;

              if (response.status == 200) {
                Navigator.pop(context); 
                _loadData();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(response.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userId == 0
          ? const Center(child: Text("Silakan Login Terlebih Dahulu"))
          : FutureBuilder<List<Schedule>>(
              future: _futureSchedules,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Belum ada jadwal. Cari konser yuk!"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    Color statusColor = Colors.grey;
                    if (item.status == 'Going') statusColor = Colors.green;
                    if (item.status == 'Done') statusColor = Colors.blue;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          if (item.imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: SizedBox(
                                height: 140,
                                width: double.infinity,
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                            ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              item.eventName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.indigo,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(item.eventDate.substring(0, 10)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.indigo,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        item.venueName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "📝 Catatan: ${item.personalNotes}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => _editItem(item),
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text("Edit"),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: () => _deleteItem(item.id!),
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    "Hapus",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomSchedule,
        backgroundColor: Colors.indigo,
        tooltip: "Tambah Jadwal Sendiri",
        child: const Icon(Icons.add),
      ),
    );
  }
}
