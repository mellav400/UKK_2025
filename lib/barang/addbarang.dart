
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/barang/tambahbarang.dart';
import 'package:ukk_kasir/kasir.dart';


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
    // final response = await Supabase.instance.client.from('produk').select();
    setState(() {
      // florist = List<Map<String, dynamic>>.from(response);
      filteredFlorist = florist;
    });
  }

  void filterflorist(String category){
    setState(() {
      this.category = category;
      if(category == 'all') {
        filteredFlorist = florist;
      }
      else {
        filteredFlorist = florist.where((item) => item['typeFlorist'] == category).toList();
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
                    'Data Product',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                  leading: Image.asset(
                    'assets/brand.png',
                    width: MediaQuery.of(context).size.width * 0.085,
                    height: MediaQuery.of(context).size.height * 0.085,
                  ),
                ),
                 ListTile(
                  onTap: () {},
                  title: Text(
                    'Data Customer',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                  leading: Image.asset(
                    'assets/brand.png',
                    width: MediaQuery.of(context).size.width * 0.085,
                    height: MediaQuery.of(context).size.height * 0.085,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: Text(
                    'Stok Barang',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                  leading: Image.asset(
                    'assets/brand.png',
                    width: MediaQuery.of(context).size.width * 0.085,
                    height: MediaQuery.of(context).size.height * 0.085,
                  ),
                ),
                ListTile(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context)=> Admin())
                    );
                  },
                  title: Text(
                    'Back',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                  leading: Image.asset(
                    'assets/brand.png',
                    width: MediaQuery.of(context).size.height * 0.075,
                    height: MediaQuery.of(context).size.height * 0.075,
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
                // Image.asset(
                //   'assets/list.png',
                //   width: MediaQuery.of(context).size.width * 0.05,
                //   height: MediaQuery.of(context).size.height * 0.05,
                // ),
                // Icon(Icons.file_copy),
                // Image.asset('assets/logo.png',
                //   width: MediaQuery.of(context).size.width * 0.19,
                //   height: MediaQuery.of(context).size.height * 0.19
                // ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Text('Product List',
                  style: GoogleFonts.poppins(
                    color: Color(0xFF181D27),
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.height * 0.025
                  )
                ),
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
                    PopupMenuItem(
                      value: 'all',
                      child: Text('All')
                    ),
                    PopupMenuItem(
                      value: 'Others',
                      child: Text('Others')),
                    PopupMenuItem(
                      value: 'Flowers',
                      child: Text('Flowers')
                    ),
                  ])
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: ListView.builder(
                // padding: EdgeInsets.all(20),
                itemCount: filteredFlorist.length,
                itemBuilder: (context, index) {
                  final list = filteredFlorist[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width *0.2,
                      // height: MediaQuery.of(context).size.height * 0.1,
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
                              Text(list['NamaProduk'] ?? 'No name',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF181D27),
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.25,
                                    height: MediaQuery.of(context).size.height * 0.043,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEFF8FF),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Center(
                                      child: Text('${list['Stok']} Portions',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF2E90FA)
                                        ),
                                      ),
                                    )
                                  ),
                                  Text('Rp${list['Harga']} / Portions',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFFA4A7AE)
                                    ),
                                  )
                                ],
                              ),
                            ] 
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(''),
                            ],
                          ),
                          Column(
                            children: [
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_vert
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    // onTap: (){
                                    //   Navigator.push(context, MaterialPageRoute(
                                    //     builder: (context) => Editproduk(data: list,)));
                                    // },
                                    child: Text('Edit')
                                  ),
                                  PopupMenuItem(
                                    // onTap: (){
                                    //   showDeleteDialog(context, list['ProdukID']);
                                    // },
                                    child: Text('Hapus')
                                  )
                                ]
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 248, 148, 168),
        foregroundColor: const Color.fromARGB(255, 248, 222, 226),
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => tambahProduk()
            )
          );
        },
        child: Icon(Icons.add)
      ),
    );
  }
}