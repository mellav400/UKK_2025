import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class tambahPelanggan extends StatefulWidget {
  const tambahPelanggan({super.key});

  @override
  _tambahPelangganState createState() => _tambahPelangganState();
}

class _tambahPelangganState extends State<tambahPelanggan> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _namapelangganController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _notelpController = TextEditingController();

 Future<void> _tambahPelanggan() async {
  if (!_formkey.currentState!.validate()) {
    return;
  }

  final namapelanggan = _namapelangganController.text;
  final alamat = _alamatController.text;
  final notelp = _notelpController.text;

  try {
    await Supabase.instance.client.from('pelanggan').insert([
      {
        'namapelanggan': namapelanggan,
        'alamat': alamat,
        'notelp': notelp,
      }
    ]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pelanggan Berhasil Ditambahkan')),
    );

    _namapelangganController.clear();
    _alamatController.clear();
    _notelpController.clear();

    Navigator.pop(context, 'success');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 230, 250),
        title: Text('Add New Customer', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Pelanggan
                Text(
                  'Name',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 31, 39)),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _namapelangganController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    prefixIcon: Icon(Icons.local_florist, color: Color.fromARGB(255, 255, 82, 82)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Alamat
                Text(
                  'Address',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 31, 39)),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.location_on, color: Color.fromARGB(255, 52, 93, 40)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16),

                // Nomor Telepon
                Text(
                  'Phone',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 31, 39)),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _notelpController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.phone, color: const Color.fromARGB(255, 54, 53, 53)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Tombol Simpan
                Center(
                  child: ElevatedButton(
                    onPressed: _tambahPelanggan,
                    child: Text(
                      'Save',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 248, 215, 255),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
