import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/penjualan/detailpenjualan.dart';
import 'package:ukk_kasir/penjualan/tambahpenjualan.dart';
import 'package:intl/intl.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  List<Map<String, dynamic>> salesData = [];
  List<Map<String, dynamic>> filteredSalesData = [];
  bool isLoading = true;
  String errorMessage = '';

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
      final response = await Supabase.instance.client.from('penjualan').select('''
        penjualanid, created_at, totalharga,
        pelanggan(pelangganid, namapelanggan, notelp, alamat),
        detailpenjualan(detailid, jumlahproduk, subtotal,
          produk(produkid, namaproduk, harga)
        )
      ''').order('created_at', ascending: false);

      print("Response dari Supabase: $response"); // Debugging Output

      if (response != null && response.isNotEmpty) {
        setState(() {
          salesData = List<Map<String, dynamic>>.from(response);
          filteredSalesData = salesData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Tidak ada data penjualan.';
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e"); // Debugging Error
      setState(() {
        errorMessage = 'Terjadi kesalahan saat mengambil data.';
        isLoading = false;
      });
    }
  }

  void filterSales(String query) {
    setState(() {
      filteredSalesData = salesData.where((sale) {
        final customerName = (sale['pelanggan']?['namapelanggan'] ?? '').toLowerCase();
        return customerName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Sales Transactions',
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
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by Customer',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: filterSales,
            ),
            SizedBox(height: 16),
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
                child: filteredSalesData.isEmpty
                    ? Center(child: Text("Tidak ada data penjualan"))
                    : ListView.builder(
                        itemCount: filteredSalesData.length,
                        itemBuilder: (context, index) {
                          final sale = filteredSalesData[index];
                          final customer = sale['pelanggan'] ?? {};
                          final details = sale['detailpenjualan'] ?? [];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPenjualan(
                                    penjualanId: sale['penjualanid'],
                                    transaksi: sale,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pelanggan: ${customer['namapelanggan'] ?? 'No Name'}',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    Text(
                                      'No Telp: ${customer['notelp'] ?? 'No Phone'}',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    Text(
                                      'Tanggal: ${sale['created_at'] ?? 'Unknown'}',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    Text(
                                      'Alamat: ${customer['alamat'] ?? 'No Address'}',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                    Divider(),
                                    Text(
                                      'Produk Dibeli: ',
                                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    if (details.isEmpty)
                                      Text(
                                        'Tidak ada produk yang dibeli',
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
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahPenjualan()),
          ).then((_) {
            fetchSalesData(); 
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
