import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahPenjualan extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const TambahPenjualan({super.key, required this.cartItems});

  @override
  _TambahPenjualanState createState() => _TambahPenjualanState();
}

class _TambahPenjualanState extends State<TambahPenjualan> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> pelangganList = [];
  int? selectedPelanggan;
  double subtotal = 0;
  DateTime tanggalTransaksi = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    calculateSubtotal();
  }

  Future<void> fetchPelanggan() async {
    final response = await supabase.from('pelanggan').select();

    setState(() {
      if (response != null && response.isNotEmpty) {
        pelangganList = List<Map<String, dynamic>>.from(response);
        selectedPelanggan = pelangganList.first['pelangganid'];
      } else {
       
        selectedPelanggan = null;
      }
    });
  }

  void calculateSubtotal() {
    setState(() {
      subtotal = widget.cartItems.fold(0.0, (sum, item) => sum + (item['harga'] * item['jumlah']));
    });
  }

  void removeFromCart(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
      calculateSubtotal();
    });
  }

  Future<void> simpanPenjualan() async {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tambahkan produk ke keranjang terlebih dahulu')),
      );
      return;
    }

    try {
      final response = await supabase.from('penjualan').insert({
        'totalharga': subtotal,
        'pelangganid': selectedPelanggan ?? 'Unknown', // Jika null, gunakan "Unknown"
        'tanggalpenjualan': tanggalTransaksi.toIso8601String(),
      }).select();

      if (response == null || response.isEmpty) throw Exception('Gagal menyimpan data penjualan');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaksi Berhasil!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Pilih Pelanggan',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
       DropdownButton<int?>(
  value: selectedPelanggan,
  hint: Text("Unknown"), 
  onChanged: (int? newValue) => setState(() => selectedPelanggan = newValue),
  items: [
    DropdownMenuItem<int?>(
      value: null,
      child: Text("Unknown"),
    ),
    ...pelangganList.map((p) => DropdownMenuItem<int?>(
      value: p['pelangganid'],
      child: Text(p['namapelanggan']),
    )),
  ],
),

          SizedBox(height: 16),
          Text(
            'Produk dalam Keranjang',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...widget.cartItems.map((item) => ListTile(
            title: Text(item['namaproduk']),
            subtitle: Text('Rp${item['harga']} x ${item['jumlah']}'),
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => removeFromCart(widget.cartItems.indexOf(item))),
          )),
          Divider(),
          Text(
            'Total: Rp${subtotal.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: simpanPenjualan,
            child: Text('Simpan'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
          ),
        ],
      ),
    );
  }
}
