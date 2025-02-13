
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase/supabase.dart';


class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  _adminState createState() => _adminState();
}

class _adminState extends State<Admin> {
  List<Map<String, dynamic>> bouquet = [];
  List<Map<String, dynamic>> filteredbouquet = [];
  String category = 'all';

  @override
  void initState() {
    super.initState();
    fetchFood();
  }

  Future<void> fetchFood() async {
    final response = await Supabase.instance.client.from('produk').select();
    setState(() {
      bouquet = List<Map<String, dynamic>>.from(response);
      filteredbouquet = bouquet;
    });
  }

  void filterfood(String category){
    setState(() {
      this.category = category;
      if(category == 'all') {
        filteredbouquet = bouquet;
      }
      else {
        filteredbouquet = bouquet.where((item) => item['typeBouquet'] == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LulaFlawrist',
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
            'assets/logo.png',
            height: MediaQuery.of(context).size.height * 0.19,
            width: MediaQuery.of(context).size.width * 0.19,
          ),
        ),
      ),
    );
  }
}