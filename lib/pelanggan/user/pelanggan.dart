
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/barang/tambahbarang.dart';
import 'package:ukk_kasir/kasir.dart';
import 'package:ukk_kasir/barang/addbarang.dart';
import 'package:ukk_kasir/penjualan/penjualan.dart';
import 'package:ukk_kasir/user/editpelanggan.dart';
import 'package:ukk_kasir/user/hapuspelanggan.dart';
import 'package:ukk_kasir/user/tambahpelanggan.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  _customerState createState() => _customerState();
}

class _customerState extends State<Customer> {
  List<Map<String, dynamic>> customer = [];
  List<Map<String, dynamic>> filteredCustomer = [];
  String sorting = 'all';

  @override
  void initState() {
    super.initState();
    fetchCustomer();
  }

  Future<void> fetchCustomer() async {
    final response = await Supabase.instance.client.from('pelanggan').select();
    setState(() {
      customer = List<Map<String, dynamic>>.from(response);
      filteredCustomer = customer;
    });
  }

  void filterflorist(String sorting){
    setState(() {
      this.sorting = sorting;
      if(sorting == 'all data') {
        filteredCustomer = customer;
      }
      else {
        filteredCustomer = customer.where((item) => item['typeCustomer'] == sorting).toList();
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
              'Customer Data',
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
                  onTap: () {},
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
                  onTap: () {
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
    Icons.shopping_cart_checkout,
    size: 25, 
    color: Color(0xFF181D27), 
  ),
                ),
                 ListTile(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context)=> Sales()) 
                    //   );
                  },
                  title: Text(
                    'Receipt',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF181D27),
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                    leading: Icon(
    Icons.description,
    size: 25, 
    color: Color(0xFF181D27), 
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
                   leading: Icon(
    Icons.arrow_back_ios_new,
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
                Text('customer data at LulaFlawrist store',
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
              
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: ListView.builder(
                // padding: EdgeInsets.all(20),
                itemCount: filteredCustomer.length,
                itemBuilder: (context, index) {
                  final list = filteredCustomer[index];
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
                              Text(list['namapelanggan'] ?? 'No name',
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
                                      child: Text('${list['alamat']} ',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF2E90FA)
                                        ),
                                      ),
                                    )
                                  ),
                                  // Text('Rp${list['Harga']} / Portions',
                                  //   style: GoogleFonts.poppins(
                                  //     color: Color(0xFFA4A7AE)
                                  //   ),
                                  // )
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
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => EditCustomer(data: list,)));
                                    },
                                    child: Text('Edit')
                                  ),
                                  PopupMenuItem(
                                     onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => HapusPelanggan(data: list,)));
                                    },
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
              builder: (context) => tambahPelanggan()
            )
          );
        },
        child: Icon(Icons.add)
      ),
    );
  }
}