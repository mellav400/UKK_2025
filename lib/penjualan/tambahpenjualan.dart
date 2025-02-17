import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahPenjualan extends StatefulWidget {
  const TambahPenjualan({super.key});

  @override
  _TambahPenjualanState createState() => _TambahPenjualanState();
}

class _TambahPenjualanState extends State<TambahPenjualan> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> produkList = [];
  List<Map<String, dynamic>> pelangganList = [];
  int selectedProduk = 0;
  int selectedPelanggan = 0;
  int jumlahProduk = 1;
  double subtotal = 0;
  DateTime tanggalTransaksi = DateTime.now();
  int stokTersedia = 0;
  
  get pilihTanggal => null;

  @override
  void initState() {
    super.initState();
    fetchProduk();
    fetchPelanggan();
  }

  Future<void> fetchProduk() async {
    try {
      final response = await supabase.from('produk').select();
      if (response != null && response.isNotEmpty) {
        setState(() {
          produkList = List<Map<String, dynamic>>.from(response);
          selectedProduk = produkList.isNotEmpty ? produkList[0]['produkid'] : 0;
          stokTersedia = produkList.isNotEmpty ? produkList[0]['stok'] : 0;
        });
      }
    } catch (e) {
      print('Error fetching produk: $e');
    }
  }

  Future<void> fetchPelanggan() async {
    try {
      final response = await supabase.from('pelanggan').select();
      if (response != null && response.isNotEmpty) {
        setState(() {
          pelangganList = List<Map<String, dynamic>>.from(response);
          selectedPelanggan = pelangganList.isNotEmpty ? pelangganList[0]['pelangganid'] : 0;
        });
      }
    } catch (e) {
      print('Error fetching pelanggan: $e');
    }
  }

Future<void> simpanPenjualan() async {
  if (selectedProduk == 0 || jumlahProduk <= 0 || selectedPelanggan == 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pilih produk, jumlah yang valid, dan pelanggan')),
    );
    return;
  }

  if (jumlahProduk > stokTersedia) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stok produk tidak cukup')),
    );
    return;
  }

  final produk = produkList.firstWhere((p) => p['produkid'] == selectedProduk);
  subtotal = produk['harga'] * jumlahProduk;

  try {
    
    final response = await supabase.from('penjualan').insert({
  'totalharga': subtotal,
  'pelangganid': selectedPelanggan,
  'tanggalpenjualan': tanggalTransaksi.toIso8601String(),
}).select(); // Supaya respons berisi data yang baru dimasukkan

if (response == null || response.isEmpty) {
  throw Exception('Gagal menyimpan data penjualan');
}

final penjualanId = response[0]['penjualanid'];

final detailResponse = await supabase.from('detailpenjualan').insert({
  'penjualanid': penjualanId,
  'produkid': selectedProduk,
  'jumlahproduk': jumlahProduk,
  'subtotal': subtotal,
  // 'waktu': tanggalTransaksi.toIso8601String(),
}).select();

if (detailResponse == null || detailResponse.isEmpty) {
  throw Exception('Gagal menyimpan detail penjualan');
}

  
    Navigator.pop(context);
  } catch (e) {
    print('Error simpan penjualan: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan saat menyimpan penjualan: $e')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Penjualan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
          
            Text(
              'Pilih Pelanggan',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            pelangganList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : DropdownButton<int>(
                    value: selectedPelanggan,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedPelanggan = newValue!;
                      });
                    },
                    isExpanded: true,
                    items: pelangganList.map<DropdownMenuItem<int>>((Map<String, dynamic> pelanggan) {
                      return DropdownMenuItem<int>(
                        value: pelanggan['pelangganid'],
                        child: Text(pelanggan['namapelanggan'] ?? 'Tidak ada nama'),
                      );
                    }).toList(),
                  ),
            SizedBox(height: 16),

            Text(
              'Pilih Produk',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            produkList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : DropdownButton<int>(
                    value: selectedProduk,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedProduk = newValue!;
                        stokTersedia = produkList.firstWhere((p) => p['produkid'] == selectedProduk)['stok'];
                        subtotal = produkList.firstWhere((p) => p['produkid'] == selectedProduk)['harga'] * jumlahProduk;
                      });
                    },
                    isExpanded: true,
                    items: produkList.map<DropdownMenuItem<int>>((Map<String, dynamic> produk) {
                      return DropdownMenuItem<int>(
                        value: produk['produkid'],
                        child: Text(produk['namaproduk'] ?? 'Tidak ada nama'),
                      );
                    }).toList(),
                  ),
            SizedBox(height: 16),

       
            Text(
              'Jumlah Produk',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  jumlahProduk = int.tryParse(value) ?? 1;
                  if (jumlahProduk > stokTersedia) {
                    jumlahProduk = stokTersedia;
                  }
                  subtotal = produkList.firstWhere((p) => p['produkid'] == selectedProduk)['harga'] * jumlahProduk;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Masukkan jumlah produk',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

         
            Text(
              'Subtotal: Rp${subtotal.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Text(
              'Tanggal Transaksi',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text(
                'Pilih Tanggal: ${tanggalTransaksi.toLocal()}'.split(' ')[0],
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: pilihTanggal,
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: (selectedProduk == 0 || selectedPelanggan == 0 || jumlahProduk == 0)
                  ? null
                  : simpanPenjualan,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
