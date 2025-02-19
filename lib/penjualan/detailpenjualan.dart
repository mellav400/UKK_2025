import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart'; 
import 'dart:html' as html;  

class DetailPenjualan extends StatefulWidget {
  final int penjualanId;
  final Map<String, dynamic> transaksi;

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
          .select('''penjualanid, created_at, totalharga,
            pelanggan(namapelanggan, alamat),
            detailpenjualan(jumlahproduk, subtotal,
              produk(namaproduk, harga)
            )''')
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
Future<void> generateAndDownloadReceipt() async {
  final pdf = pw.Document();
  final dateFormatter = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

  final imageBytes = await rootBundle.load('assets/logo.png');
  final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

  
  final pageTheme = pw.PageTheme(
    pageFormat: PdfPageFormat(80 * PdfPageFormat.mm, double.infinity, marginAll: 5),
  );

  pdf.addPage(
    pw.Page(
      pageTheme: pageTheme,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(image, width: 60, height: 60),
            pw.Text('Lula Flawrist', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text('National Road III No. 40, Blitar', style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 5),
            pw.Text('Shopping Receipt', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text('Date: $dateFormatter', style: pw.TextStyle(fontSize: 10)),
            pw.Text('Customer: ${transaksi?['pelanggan']?['namapelanggan'] ?? 'Umum'}', style: pw.TextStyle(fontSize: 10)),
            pw.Divider(),
            pw.Text('Purchase details:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            
            
            pw.ListView.builder(
              itemCount: detailPenjualan.length,
              itemBuilder: (pw.Context context, int index) {
                final item = detailPenjualan[index];
                final produk = item['produk'] ?? {};
                int jumlah = (item['jumlahproduk'] ?? 0) as int;
                int harga = (produk['harga'] ?? 0) as int;
                int subtotal = jumlah * harga;

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${produk['namaproduk'] ?? 'Tidak ada nama'}', style: pw.TextStyle(fontSize: 10)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('$jumlah x Rp${NumberFormat("#,###", "id_ID").format(harga)}',
                            style: pw.TextStyle(fontSize: 10)),
                        pw.Text('Rp${NumberFormat("#,###", "id_ID").format(subtotal)}',
                            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.SizedBox(height: 3),
                  ],
                );
              },
            ),
            
            pw.Divider(),
            pw.Text('Total Bayar: Rp${NumberFormat("#,###", "id_ID").format(transaksi?['totalharga'] ?? 0)}',
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text('Thanks for coming, see you soon!', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
              pw.Text('©Lulaflawrist2025', style: pw.TextStyle(fontSize: 7,)),
            pw.SizedBox(height: 10),
          ],
        );
      },
    ),
  );

  if (kIsWeb) {
    final bytes = await pdf.save();
    final buffer = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(buffer);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'struk_penjualan_${widget.penjualanId}.pdf';
    anchor.click();
    html.Url.revokeObjectUrl(url);
  } else {
    if (await Permission.storage.request().isGranted) {
      final output = await getExternalStorageDirectory();
      final file = File('${output!.path}/struk_penjualan_${widget.penjualanId}.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Struk berhasil diunduh!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied!')),
      );
    }
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
                              '$jumlah x Rp${NumberFormat("#,###","id_ID").format(harga)} = Rp${NumberFormat("#,###","id_ID").format(subtotal)}',
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Text(
                    'Total Pembayaran: Rp${NumberFormat("#,###","id_ID").format( transaksi?['totalharga']) ?? 0}',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: generateAndDownloadReceipt,
                    child: Text('Unduh Struk', style: GoogleFonts.poppins()),
                  ),
                ],
              ),
      ),
    );
  }
}
