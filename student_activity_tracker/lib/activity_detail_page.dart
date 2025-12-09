// lib/activity_detail_page.dart

import 'package:flutter/material.dart';
import 'model/activity_model.dart';

class ActivityDetailPage extends StatelessWidget {
  final Activity activity;
  const ActivityDetailPage({super.key, required this.activity});

  // Helper function untuk detail row (penting untuk menghindari error)
  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Expanded(child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(value, style: TextStyle(color: color))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Aktivitas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity.name, style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            _buildDetailRow(context, Icons.category, 'Kategori', activity.category),
            _buildDetailRow(context, Icons.schedule, 'Durasi', '${activity.duration} jam'),
            _buildDetailRow(context, activity.done ? Icons.check_circle : Icons.radio_button_unchecked, 'Status', activity.done ? 'Selesai' : 'Belum selesai', color: activity.done ? Colors.green : Colors.orange),
            const SizedBox(height: 20),
            const Text('Catatan Tambahan 📝', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: Text(activity.notes.isEmpty ? 'Tidak ada catatan.' : activity.notes, style: TextStyle(fontStyle: activity.notes.isEmpty ? FontStyle.italic : FontStyle.normal)),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Kembali'))),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text('Konfirmasi Hapus'),
                                content: const Text('Yakin ingin menghapus aktivitas ini?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                                  TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Hapus')),
                                ],
                              ));
                      if (confirm == true) Navigator.pop(context, 'deleted');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, foregroundColor: Colors.white),
                    child: const Text('Hapus Aktivitas'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}