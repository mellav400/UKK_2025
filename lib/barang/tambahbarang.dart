import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahProduk extends StatefulWidget {
  const TambahProduk({super.key});

  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _NamaProdukController = TextEditingController();
  final TextEditingController _HargaController = TextEditingController();
  final TextEditingController _StokController = TextEditingController();
  final _KategoriController = SingleValueDropDownController();

  bool isLoading = false;

  Future<void> _tambahProduk() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_KategoriController.dropDownValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori produk harus dipilih!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final produk = _NamaProdukController.text;
      final harga = int.tryParse(_HargaController.text) ?? 0;
      final stok = int.tryParse(_StokController.text) ?? 0;
      final kategori = _KategoriController.dropDownValue!.value;

      await Supabase.instance.client.from('produk').insert({
        'namaproduk': produk,
        'harga': harga,
        'stok': stok,
        'kategori': kategori,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk Berhasil Ditambahkan')),
      );

      _NamaProdukController.clear();
      _HargaController.clear();
      _StokController.clear();
      _KategoriController.dropDownValue = null;

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 230, 250),
        title: Text('Add New Product', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Product Name', 'Product name', _NamaProdukController, Icons.local_florist),
                _buildTextField('Price', 'Price', _HargaController, Icons.money, isNumber: true),
                _buildTextField('Stock Product', 'Stock Product', _StokController, Icons.storage, isNumber: true),

                Text(
                  'Category',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 31, 39)),
                ),
                SizedBox(height: 8),
                DropDownTextField(
                  controller: _KategoriController,
                  textFieldDecoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.category, color: Color.fromARGB(255, 163, 142, 255)),
                  ),
                  dropDownList: [
                    DropDownValueModel(name: 'Fresh flowers', value: 'Fresh flowers'),
                    DropDownValueModel(name: 'Bouquet', value: 'Bouquet'),
                    DropDownValueModel(name: 'GiftBox', value: 'GiftBox'),
                    DropDownValueModel(name: 'Single Bouquet', value: 'Single Bouquet'),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kategori produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _tambahProduk,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Simpan',
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

  Widget _buildTextField(String label, String hint, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 31, 39)),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
          decoration: InputDecoration(
            labelText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(icon, color: Colors.purple),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
