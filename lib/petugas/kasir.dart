import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/penjualan/tambahpenjualan.dart';

class Pelanggan extends StatefulWidget {
  const Pelanggan({super.key});

  @override
  _PelangganState createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  List<Map<String, dynamic>> florist = [];
  List<Map<String, dynamic>> filteredFlorist = [];
  List<Map<String, dynamic>> cart = [];
  String category = 'all';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFlorist();
    searchController.addListener(() {
      searchFlorist(searchController.text);
    });
  }

  Future<void> fetchFlorist() async {
    final response = await Supabase.instance.client.from('produk').select();
    setState(() {
      florist = List<Map<String, dynamic>>.from(response);
      filteredFlorist = florist;
    });
  }

  void searchFlorist(String query) {
    setState(() {
      filteredFlorist = query.isEmpty
          ? florist
          : florist
              .where((item) =>
                  item['namaproduk'].toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

 void addToCart(Map<String, dynamic> item) {
  setState(() {
    int index = cart.indexWhere((cartItem) => cartItem['produkid'] == item['produkid']);

    if (index != -1) {
      cart[index]['jumlah'] += 1;
    } else {
      cart.add({
        'produkid': item['produkid'],
        'namaproduk': item['namaproduk'],
        'harga': item['harga'],
        'jumlah': 1,
      });
    }
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${item['namaproduk']} ditambahkan ke keranjang!')),
  );
}

void goToCheckout() {
  if (cart.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Keranjang masih kosong! Tambahkan produk terlebih dahulu.')),
    );
    return;
  }

//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => TambahPenjualan(cartItems: List.from(cart)), // Kirim cartItems
//     ),
//   );
// }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 245, 249),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Lulaflawrist', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: goToCheckout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFlorist.length,
              itemBuilder: (context, index) {
                final item = filteredFlorist[index];
                return GestureDetector(
                  onTap: () => addToCart(item),
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(item['namaproduk']),
                      subtitle: Text('Rp${item['harga']} - Stok: ${item['stok']}'),
                      trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}