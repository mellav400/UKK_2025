import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/loginpage.dart';
import 'package:ukk_kasir/logoutpage.dart';
import 'package:ukk_kasir/penjualan/penjualan.dart';
import 'supabase.dart';
import 'package:ukk_kasir/barang/addbarang.dart';
import 'package:intl/intl.dart';
class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<Map<String, dynamic>> florist = [];
  List<Map<String, dynamic>> filteredFlorist = [];
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

  void filterFlorist(String category) {
    setState(() {
      this.category = category;
      if (category == 'all') {
        filteredFlorist = florist;
      } else {
        filteredFlorist =
            florist.where((item) => item['typeFlorist'] == category).toList();
      }
    });
  }

  void searchFlorist(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFlorist = florist;
      } else {
        filteredFlorist = florist
            .where((item) => item['namaproduk']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    // Text(
                    //   'LulaFlawrist',
                    //   style: GoogleFonts.poppins(
                    //       color: Color(0xFF181D27),
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: MediaQuery.of(context).size.height * 0.03),
                    // )
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
    'Data Collection',
    style: GoogleFonts.poppins(
      color: Color(0xFF181D27),
      fontSize: MediaQuery.of(context).size.height * 0.02,
    ),
  ),
  leading: Icon(
    Icons.data_usage,
    size: 25, 
    color: Color(0xFF181D27), 
  ),
),
ListTile(
  onTap: () {
   
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Loginpage()), 
      (route) => false,
    );
  },
  title: Text(
    'Logout',
    style: GoogleFonts.poppins(
      color: Color(0xFF181D27),
      fontSize: MediaQuery.of(context).size.height * 0.02,
    ),
  ),
  leading: Icon(
    Icons.logout,
    size: 25, 
    color: Color(0xFF181D27), 
  ),
),

                ListTile(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context)=> Sales())
                    );
                  },
                  title: Text(
                    'Sales',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                  leading: Icon(
    Icons.insert_chart_outlined,
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
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: GoogleFonts.poppins(),
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                PopupMenuButton<String>(
                  icon: Icon(Icons.sort),
                  onSelected: filterFlorist,
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'all', child: Text('All')),
                    PopupMenuItem(value: 'Others', child: Text('Others')),
                    PopupMenuItem(value: 'Flowers', child: Text('Flowers')),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFlorist.length,
                itemBuilder: (context, index) {
                  final item = filteredFlorist[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['namaproduk'] ?? 'No name',
                                  style: GoogleFonts.poppins(
                                      color: Color(0xFF181D27),
                                      fontWeight: FontWeight.w600)),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEFF8FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Text('${item['stok']} product',
                                        style: GoogleFonts.poppins(
                                            color: Color(0xFF2E90FA))),
                                  ),
                                  SizedBox(width: 10),
                                  Text('Rp.${NumberFormat("#,###", "id_ID").format(item['harga'])}',
                                      style: GoogleFonts.poppins(
                                          color: Color(0xFFA4A7AE))),
                                ],
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
    );
  }
}
