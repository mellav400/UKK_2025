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
  final TextEditingController jumlahController = TextEditingController();

  List<Map<String, dynamic>> pelangganList = [];
  List<Map<String, dynamic>> produkList = [];
  String? selectedPelanggan;
  String? selectedProduk;
  int hargaProduk = 0;
  bool isLoading = false;
  bool isFetching = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // ✅ Mengambil data pelanggan & produk bersamaan
  Future<void> fetchData() async {
    setState(() {
      isFetching = true;
    });

    try {
      final pelangganResponse = await supabase
          .from('pelanggan')
          .select('pelangganid, namapelanggan');
      final produkResponse = await supabase
          .from('produk')
          .select('produkid, namaproduk, harga');

      setState(() {
        pelangganList = List<Map<String, dynamic>>.from(pelangganResponse);
        produkList = List<Map<String, dynamic>>.from(produkResponse);
        isFetching = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: $e')),
      );
      setState(() {
        isFetching = false;
      });
    }
  }

  
  Future<void> simpanTransaksi() async {
    if (selectedPelanggan == null || selectedProduk == null || jumlahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap lengkapi semua data!')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
     
      final penjualanResponse = await supabase
          .from('penjualan')
          .insert({
            'created_at': DateTime.now().toIso8601String(),
            'pelangganid': selectedPelanggan
          })
          .select()
          .single();

      final penjualanId = penjualanResponse['id'];

      
      await supabase.from('detailpenjualan').insert({
        'penjualanid': penjualanId,
        'produkid': selectedProduk,
        'jumlahproduk': int.parse(jumlahController.text),
        'subtotal': hargaProduk
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi berhasil disimpan!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Penjualan', style: GoogleFonts.poppins())),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isFetching
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
             
                  DropdownButtonFormField<String>(
                    value: selectedPelanggan,
                    items: pelangganList.isNotEmpty
                        ? pelangganList.map((pelanggan) {
                            return DropdownMenuItem(
                              value: pelanggan['pelangganid'].toString(),
                              child: Text(pelanggan['namapelanggan']),
                            );
                          }).toList()
                        : [],
                    onChanged: (value) {
                      setState(() => selectedPelanggan = value);
                    },
                    decoration: InputDecoration(labelText: 'Pilih Pelanggan'),
                  ),
                  SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedProduk,
                    items: produkList.isNotEmpty
                        ? produkList.map((produk) {
                            return DropdownMenuItem(
                              value: produk['produkid'].toString(),
                              child: Text('${produk['namaproduk']} - Rp${produk['harga']}'),
                              onTap: () {
                                setState(() {
                                  hargaProduk = produk['harga'];
                                });
                              },
                            );
                          }).toList()
                        : [],
                    onChanged: (value) {
                      setState(() => selectedProduk = value);
                    },
                    decoration: InputDecoration(labelText: 'Pilih Produk'),
                  ),
                  SizedBox(height: 16),

                  
                  TextField(
                    controller: jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Jumlah'),
                  ),
                  SizedBox(height: 16),

              
                  ElevatedButton(
                    onPressed: isLoading ? null : simpanTransaksi,
                    child: isLoading ? CircularProgressIndicator() : Text('Simpan Transaksi'),
                  ),
                ],
              ),
      ),
    );
  }
}
