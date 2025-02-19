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
  // final List<Map<String
  List<Map<String, dynamic>> produkList = [];
  List<Map<String, dynamic>> pelangganList = [];
  int selectedProduk = 0;
  int selectedPelanggan = 0;
  int jumlahProduk = 1;
  double subtotal = 0;
  DateTime tanggalTransaksi = DateTime.now();
  int stokTersedia = 0;

  List<Map<String, dynamic>> cart = []; // Keranjang belanja

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat produk: $e')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat pelanggan: $e')),
      );
    }
  }

  void tambahKeKeranjang() {
    if (selectedProduk == 0 || jumlahProduk <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih produk dan jumlah yang valid')),
      );
      return;
    }

    final produk = produkList.firstWhere((p) => p['produkid'] == selectedProduk);
    double subtotalItem = produk['harga'] * jumlahProduk;

   
    var existingItem = cart.firstWhere(
      (item) => item['produkid'] == selectedProduk,
      orElse: () => {},
    );

    if (existingItem.isNotEmpty) {
    
      existingItem['jumlah'] += jumlahProduk;
      existingItem['subtotal'] = existingItem['harga'] * existingItem['jumlah'];
    } else {
  
      cart.add({
        'produkid': selectedProduk,
        'namaproduk': produk['namaproduk'],
        'harga': produk['harga'],
        'jumlah': jumlahProduk,
        'subtotal': subtotalItem,
      });
    }

    // Update subtotal total
    setState(() {
      subtotal = cart.fold(0.0, (sum, item) => sum + item['subtotal']);
      stokTersedia = produk['stok'] - jumlahProduk;
    });
  }

  Future<void> simpanPenjualan() async {
    if (selectedPelanggan == 0 || cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih pelanggan dan tambahkan produk ke keranjang')),
      );
      return;
    }

    try {
      // Simpan data penjualan ke tabel penjualan
      final response = await supabase.from('penjualan').insert({
        'totalharga': subtotal,
        'pelangganid': selectedPelanggan,
        'tanggalpenjualan': tanggalTransaksi.toIso8601String(),
      }).select();

      if (response == null || response.isEmpty) {
        throw Exception('Gagal menyimpan data penjualan');
      }

      final penjualanId = response[0]['penjualanid'];

 
      for (var item in cart) {
        await supabase.from('detailpenjualan').insert({
          'penjualanid': penjualanId,
          'produkid': item['produkid'],
          'jumlahproduk': item['jumlah'],
          'subtotal': item['subtotal'],
        }).select();

        
        final produk = produkList.firstWhere((p) => p['produkid'] == item['produkid']);
        final stokTersedia = produk['stok'];

        if (stokTersedia - item['jumlah'] < 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Stok produk tidak cukup')),
          );
          return;
        }

        await supabase.from('produk').update({
          'stok': stokTersedia - item['jumlah'],
        }).eq('produkid', item['produkid']);
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
      appBar: AppBar(title: Text('Add Sales')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Choose Customer',
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
              'Choose Product',
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
              'Quantity',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  jumlahProduk = int.tryParse(value) ?? 1;
                  if (jumlahProduk > stokTersedia) {
                    jumlahProduk = stokTersedia;
                  }
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Input product qty',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: tambahKeKeranjang,
              child: Text('Add to Cart'),
            ),
            SizedBox(height: 16),

            Text(
              'Cart',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...cart.map((item) {
              return ListTile(
                title: Text(item['namaproduk']),
                subtitle: Text('Qty: ${item['jumlah']} | Subtotal: Rp${item['subtotal']}'),
              );
            }).toList(),
            SizedBox(height: 16),

            Text(
              'Total: Rp.${subtotal.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: (selectedPelanggan == 0 || cart.isEmpty)
                  ? null
                  : simpanPenjualan,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
