import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/barang/editbarang.dart';
import 'package:ukk_kasir/barang/hapusbarang.dart';
import 'package:ukk_kasir/barang/tambahbarang.dart';
import 'package:ukk_kasir/kasir.dart';
import 'package:ukk_kasir/user/pelanggan.dart';

class Barang extends StatefulWidget {
  const Barang({super.key});

  @override
  _adminState createState() => _adminState();
}

class _adminState extends State<Barang> {
  List<Map<String, dynamic>> florist = [];
  List<Map<String, dynamic>> filteredFlorist = [];
  String category = 'all';

  @override
  void initState() {
    super.initState();
    fetchFlorist();
  }

  Future<void> fetchFlorist() async {
    final response = await Supabase.instance.client.from('produk').select();
    setState(() {
      florist = List<Map<String, dynamic>>.from(response);
      filteredFlorist = florist;
    });
  }

  void filterflorist(String category) {
    setState(() {
      this.category = category;
      if (category == 'all') {
        filteredFlorist = florist;
      } else {
        filteredFlorist = florist.where((item) => item['typeFlorist'] == category).toList();
      }
    });
  }

  // Function to simulate product deletion
  Future<void> deleteProduct(String productId) async {
    final response = await Supabase.instance.client.from('produk').delete().eq('id', productId);
    if (response.error == null) {
      // If the product is deleted successfully, reload the data
      fetchFlorist();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 245, 249),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lulaflawrist',
              style: GoogleFonts.poppins(
                  color: Color(0xFF181D27),
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Image.asset(
            'assets/brand.png',
            height: MediaQuery.of(context).size.height * 0.19,
            width: MediaQuery.of(context).size.width * 0.19,
          ),
        ),
      ),
      // actions: [
      //   IconButton()
      // ]
      endDrawer: Drawer(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: MediaQuery.of(context).size.height * 0.20,
                    ),
                  ],
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Barang()),
                    );
                  },
                  title: Text(
                    'Product Data',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                  leading: Icon(
                    Icons.data_usage,
                    size: 25,
                    color: Color(0xFF181D27),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Customer()),
                    );
                  },
                  title: Text(
                    'Customer Data',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                  leading: Icon(
                    Icons.assignment_ind_sharp,
                    size: 25,
                    color: Color(0xFF181D27),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: Text(
                    'Product Stock',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                  leading: Icon(
                    Icons.app_registration_rounded,
                    size: 25,
                    color: Color(0xFF181D27),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Admin()),
                    );
                  },
                  title: Text(
                    'Back',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                  leading: Icon(
                    Icons.back_hand,
                    size: 25,
                    color: Color(0xFF181D27),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Text('Data Product Collection',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.height * 0.025)),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.73,
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'Search',
                        labelStyle: GoogleFonts.poppins(),
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.2)))),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                PopupMenuButton<String>(
                    icon: Icon(Icons.sort),
                    onSelected: filterflorist,
                    itemBuilder: (context) => [
                          PopupMenuItem(value: 'all', child: Text('All')),
                          PopupMenuItem(value: 'Others', child: Text('Others')),
                          PopupMenuItem(value: 'Flowers', child: Text('Flowers')),
                        ])
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFlorist.length,
                itemBuilder: (context, index) {
                  final list = filteredFlorist[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(list['namaproduk'] ?? 'No name',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF181D27),
                                    fontWeight: FontWeight.w600,
                                  )),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.25,
                                    height: MediaQuery.of(context).size.height * 0.043,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEFF8FF),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: Text('${list['stok']} product',
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFF2E90FA),
                                          )),
                                    ),
                                  ),
                                    Text('Rp.${NumberFormat("#,###", "id_ID").format(list['harga'])}',
                                      style: GoogleFonts.poppins(
                                          color: Color(0xFFA4A7AE))),
                                ]
                              ),
                            ],
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProduk(data: list)),
                                  );
                                },
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  // Show confirmation dialog for deletion
                                // Show confirmation dialog for deletion
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Product',
        style: GoogleFonts.poppins(
          color: Color(0xFF181D27),
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this product?',
        style: GoogleFonts.poppins(
          color: Color(0xFF181D27),
          fontSize: 16,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              color: Color(0xFF181D27),
              fontSize: 16,
            ),
          ),
          onPressed: () {
            Navigator.pop(context); // Close dialog
          },
        ),
        TextButton(
          child: Text(
            'Delete',
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 16,
            ),
          ),
          onPressed: () async {
            // Simulate product deletion
            await deleteProduct(list['id']);
            Navigator.pop(context); // Close dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Product deleted successfully!')),
            );
          },
        ),
      ],
    );
  },
);

                                },
                                child: Text('Delete'),
                              ),
                            ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 248, 148, 168),
        foregroundColor: const Color.fromARGB(255, 248, 222, 226),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahProduk()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
