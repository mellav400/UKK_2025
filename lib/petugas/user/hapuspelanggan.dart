import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HapusPelanggan extends StatefulWidget {
  final Map data;
  const HapusPelanggan({super.key, required this.data});

  @override
  _HapusPelangganState createState() => _HapusPelangganState();
}

class _HapusPelangganState extends State<HapusPelanggan> {
  bool _isLoading = false;

  Future<void> _hapusPelanggan() async {
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('pelangganid', widget.data['pelangganid']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pelanggan berhasil dihapus!')),
      );

      Navigator.pop(context, 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pelanggan: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 82, 82),
        title: Text(
          'Hapus Pelanggan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus pelanggan berikut?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 53, 31, 39),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nama Pelanggan: ${widget.data['namapelanggan']}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color.fromARGB(255, 53, 31, 39),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _hapusPelanggan,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Hapus',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 82, 82),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
