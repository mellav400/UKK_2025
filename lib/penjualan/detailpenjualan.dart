import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPenjualan extends StatefulWidget {
  final int penjualanId;
  final Map<String, dynamic> transaksi; // ✅ Perbaikan: Menambahkan transaksi sebagai parameter wajib

  const DetailPenjualan({super.key, required this.penjualanId, required this.transaksi});

  @override
  _DetailPenjualanState createState() => _DetailPenjualanState();
}

class _DetailPenjualanState extends State<DetailPenjualan> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? transaksi;
  List<Map<String, dynamic>> detailPenjualan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetailPenjualan();
  }

  Future<void> fetchDetailPenjualan() async {
    try {
      final response = await supabase
          .from('penjualan')
          .select('''
            penjualanid, created_at, totalharga,
            pelanggan(namapelanggan, alamat),
            detailpenjualan(jumlahproduk, subtotal,
              produk(namaproduk, harga)
            )
          ''')
          .eq('penjualanid', widget.penjualanId)
          .single();

      setState(() {
        transaksi = response;
        detailPenjualan = List<Map<String, dynamic>>.from(response['detailpenjualan'] ?? []);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching detail: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Penjualan', style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: transaksi == null
            ? Center(child: Text('Data tidak ditemukan'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pelanggan: ${transaksi?['pelanggan']?['namapelanggan'] ?? 'Tidak diketahui'}',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Alamat: ${transaksi?['pelanggan']?['alamat'] ?? 'Tidak ada alamat'}',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  Text(
                    'Tanggal: ${transaksi?['created_at'] ?? 'Tidak diketahui'}',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  Divider(),
                  Text(
                    'Produk yang Dibeli:',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: detailPenjualan.length,
                      itemBuilder: (context, index) {
                        final item = detailPenjualan[index];
                        final produk = item['produk'] ?? {};
                        int jumlah = (item['jumlahproduk'] ?? 0) as int;
                        int harga = (produk['harga'] ?? 0) as int;
                        int subtotal = jumlah * harga;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(produk['namaproduk'] ?? 'Tidak ada nama', style: GoogleFonts.poppins(fontSize: 14)),
                            subtitle: Text(
                              '$jumlah x Rp$harga = Rp$subtotal',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Text(
                    'Total Pembayaran: Rp${transaksi?['totalharga'] ?? 0}',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
