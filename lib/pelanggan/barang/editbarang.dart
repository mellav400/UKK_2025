import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProduk extends StatefulWidget {
  final Map data;
  const EditProduk({super.key, required this.data});

  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaProdukController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;
  late SingleValueDropDownController _kategoriController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaProdukController = TextEditingController(text: widget.data['namaproduk']);
    _hargaController = TextEditingController(text: widget.data['harga'].toString());
    _stokController = TextEditingController(text: widget.data['stok'].toString());
    _kategoriController = SingleValueDropDownController(
      data: widget.data['kategori'] != null
          ? DropDownValueModel(name: widget.data['kategori'], value: widget.data['kategori'])
          : null,
    );
  }

  Future<void> _editProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final nama = _namaProdukController.text;
    final harga = int.tryParse(_hargaController.text) ?? 0;
    final stok = int.tryParse(_stokController.text) ?? 0;
    final kategori = _kategoriController.dropDownValue?.value ?? ""; // Pastikan kategori tidak null

    try {
      await Supabase.instance.client
          .from('produk')
          .update({
            'namaproduk': nama,
            'harga': harga,
            'stok': stok,
            'kategori': kategori
          })
          .eq('produkid', widget.data['produkid']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui!')),
      );
      Navigator.pop(context, 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui produk: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 248, 215, 255),
        title: Text(
          'Product Edit',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Produk
                Text(
                  'Product Name',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 31, 39),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _namaProdukController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 251, 251),
                    prefixIcon: const Icon(Icons.local_florist, color: Color.fromARGB(255, 255, 82, 82)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Harga Produk
                Text(
                  'Price',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 31, 39),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _hargaController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 250, 250),
                    prefixIcon: const Icon(Icons.money, color: Color.fromARGB(255, 52, 93, 40)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga produk tidak boleh kosong';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Stok Produk
                Text(
                  'Stock',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 31, 39),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _stokController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 246, 246),
                    prefixIcon: const Icon(Icons.storage, color: Color.fromARGB(255, 54, 53, 53)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok produk tidak boleh kosong';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Kategori Produk
                Text(
                  'Cathegory',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 31, 39),
                  ),
                ),
                const SizedBox(height: 8),
                DropDownTextField(
                  controller: _kategoriController,
                  textFieldDecoration: InputDecoration(
                    labelText: 'Cathegory',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 244, 244),
                  ),
                  dropDownList: const [
                    DropDownValueModel(name: 'Fresh flowers', value: 'Fresh flowers'),
                    DropDownValueModel(name: 'Bouquet', value: 'Bouquet'),
                    DropDownValueModel(name: 'GiftBox', value: 'GiftBox'),
                    DropDownValueModel(name: 'Single Bouquet', value: 'Single Bouquet'),
                  ],
                ),
                const SizedBox(height: 20),

                // Tombol Simpan dengan Loading
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _editProduct,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Save', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
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
