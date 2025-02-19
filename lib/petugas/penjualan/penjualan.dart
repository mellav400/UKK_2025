import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  List<Map<String, dynamic>> salesData = [];
  bool isLoading = true;
  String errorMessage = '';
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    fetchSalesData();
  }

  Future<void> fetchSalesData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'User tidak ditemukan';
          isLoading = false;
        });
        return;
      }

      final response = await supabase
          .from('penjualan')
          .select('''
        penjualanid, created_at, totalharga,
        detailpenjualan(detailid, jumlahproduk, subtotal,
          produk(produkid, namaproduk, harga)
        )
      ''')
          .eq('pelangganid', user.id)
          .order('created_at', ascending: false);

      if (response != null && response.isNotEmpty) {
        setState(() {
          salesData = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Tidak ada riwayat transaksi.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan saat mengambil data.';
        isLoading = false;
      });
    }
  }

  void downloadStruk(Map<String, dynamic> sale) {
    // Di sini, implementasikan fungsi untuk menggenerate PDF struk
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Struk berhasil diunduh!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Riwayat Pesanan',
          style: GoogleFonts.poppins(
            color: Color(0xFF181D27),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Center(
                child: Text(
                  errorMessage,
                  style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: salesData.isEmpty
                    ? Center(child: Text("Tidak ada riwayat transaksi"))
                    : ListView.builder(
                        itemCount: salesData.length,
                        itemBuilder: (context, index) {
                          final sale = salesData[index];
                          final details = sale['detailpenjualan'] ?? [];

                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal: ${DateFormat('dd MMM yyyy').format(DateTime.parse(sale['created_at']))}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  Divider(),
                                  Text(
                                    'Produk Dibeli:',
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  if (details.isEmpty)
                                    Text(
                                      'Tidak ada produk dalam pesanan ini',
                                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
                                    )
                                  else
                                    ...details.map<Widget>((item) {
                                      final product = item['produk'] ?? {};
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${product['namaproduk'] ?? 'Unknown Product'}',
                                              style: GoogleFonts.poppins(fontSize: 14),
                                            ),
                                            Text(
                                              'Qty: ${item['jumlahproduk'] ?? 0} - Rp${product['harga'] ?? 0}',
                                              style: GoogleFonts.poppins(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  Divider(),
                                  Text(
                                    'Total Pembayaran: Rp.${NumberFormat('#,###').format(sale['totalharga'] ?? 0)}',
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    onPressed: () => downloadStruk(sale),
                                    icon: Icon(Icons.download),
                                    label: Text('Unduh Struk'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
