import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/views/layout/footer.dart';
import 'package:webui/views/layout/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 150,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 150,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = !kIsWeb || MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Jumbotron
                  Container(
                    height: isMobile
                        ? MediaQuery.of(context).size.height * 0.15
                        : MediaQuery.of(context).size.height * 0.5,
                    child: Image.asset(
                      'assets/images/Banner.png',
                      fit: BoxFit.cover,
                      height: isMobile
                          ? 50
                          : MediaQuery.of(context).size.height * 0.5,
                    ),
                  ),

                  // Small Image Cards
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SmallImageCard(imagePath: 'assets/images/netmonk.jpeg'),
                        SmallImageCard(imagePath: 'assets/images/pijar.jpeg'),
                        SmallImageCard(imagePath: 'assets/images/oca.jpeg'),
                        SmallImageCard(imagePath: 'assets/images/hotel.jpeg'),
                        SmallImageCard(imagePath: 'assets/images/ruko.jpeg'),
                        SmallImageCard(
                            imagePath: 'assets/images/education.jpeg'),
                        SmallImageCard(imagePath: 'assets/images/finance.jpeg'),
                      ],
                    ),
                  ),

                  Padding(
                    padding: isMobile
                        ? const EdgeInsets.all(5.0)
                        : const EdgeInsets.all(16.0),
                    child: isMobile
                        ? Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 100,
                                  color: Colors.white,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/info/1.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Tingkatkan bisnis Anda dengan kecepatan internet super cepat dan konektivitas stabil dari Telkom',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    32,
                                alignment: Alignment.centerRight,
                                height: 200,
                                color: Colors.white,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/info/1.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    32,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tingkatkan bisnis Anda dengan kecepatan internet super cepat dan konektivitas stabil dari Telkom',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),

                  Padding(
                    padding: isMobile
                        ? const EdgeInsets.all(5.0)
                        : const EdgeInsets.all(16.0),
                    child: isMobile
                        ? Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Nikmati keamanan data yang terjamin dan layanan pelanggan profesional yang siap membantu kapan saja.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  color: Colors.white,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/info/2.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    32,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Nikmati keamanan data yang terjamin dan layanan pelanggan profesional yang siap membantu kapan saja.',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    32,
                                alignment: Alignment.centerLeft,
                                height: 200,
                                color: Colors.white,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/info/2.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),

                  Padding(
                    padding: isMobile
                        ? const EdgeInsets.all(8.0)
                        : const EdgeInsets.all(16.0),
                    child: isMobile
                        ? Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 100,
                                  color: Colors.white,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/info/3.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Pilih paket fleksibel kami yang sesuai dengan kebutuhan bisnis Anda dan rasakan inovasi terbaru untuk mendukung pertumbuhan dan efisiensi.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    32,
                                alignment: Alignment.centerRight,
                                height: 200,
                                color: Colors.white,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/info/3.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    32,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pilih paket fleksibel kami yang sesuai dengan kebutuhan bisnis Anda dan rasakan inovasi terbaru untuk mendukung pertumbuhan dan efisiensi.',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),

                  // Horizontal Scrollable Product List
                  Padding(
                    padding: isMobile
                        ? const EdgeInsets.only(top: 8, bottom: 10)
                        : const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: _scrollLeft,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: isMobile ? 300 : 400,
                            child: ListView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              children: [
                                ProductCard(
                                    'Paket 1P HSI Bisnis',
                                    'assets/images/product/1.png',
                                    'Paket internet bisnis dengan kecepatan tinggi yang dirancang untuk kebutuhan dasar bisnis Anda, tanpa batasan kuota dan FUP. Cocok untuk operasional sehari-hari yang memerlukan koneksi stabil.',
                                    '50 MBPS',
                                    '275.000',
                                    '100 MBPS',
                                    '430.000',
                                    '150 MBPS',
                                    '650.000'),
                                ProductCard(
                                    'Paket 2P HSI Bisnis \n(Internet + Telepon)',
                                    'assets/images/product/2.png',
                                    'Paket lengkap yang menggabungkan internet cepat dengan layanan telepon, memberikan solusi komunikasi dan konektivitas yang efisien untuk bisnis Anda. Termasuk kuota telepon lokal dengan tarif hemat',
                                    '50 MBPS + Telp',
                                    '315.000',
                                    '100 MBPS + Telp',
                                    '480.000',
                                    '150 MBPS + Telp',
                                    '715.000'),
                                ProductCard(
                                    'Paket HSI Bisnis + Bundling',
                                    'assets/images/product/3.png',
                                    'Paket bundling yang mencakup internet cepat dan berbagai layanan tambahan seperti IPTV dan phone service. Didesain untuk meningkatkan efisiensi dan hiburan di kantor Anda.',
                                    '50 MBPS + IPTV',
                                    '305.000',
                                    '50 MBPS + Phone Service',
                                    '330.000',
                                    '100 MBPS + IPTV',
                                    '470.000'),
                                ProductCard(
                                    'Indibiz OCA',
                                    'assets/images/product/4.png',
                                    'Solusi internet bisnis dengan integrasi platform Omnichannel Communication dari OCA. Meningkatkan efisiensi layanan pelanggan dengan komunikasi yang lebih terstruktur dan terintegrasi',
                                    '50 MBPS + SMS Blast',
                                    '340.000',
                                    '50 MBPS + Fitur Quick Reply + SMS Blast',
                                    '400.000',
                                    '100 MBPS + All OCA (SMS Blast + Quick Reply + Integated Social Media on OCA)',
                                    '800.000'),
                                ProductCard(
                                    'Indibiz Netmonk',
                                    'assets/images/product/5.png',
                                    'Paket internet dengan fitur monitoring performa jaringan menggunakan Netmonk. Memastikan koneksi internet Anda selalu optimal dan bebas gangguan dengan tools pemantauan yang canggih',
                                    '50 MBPS + Real Time Monitoring Network',
                                    '400.000',
                                    '50 MBPS + Real Time Monitoring Network + Remote Access',
                                    '650.000',
                                    '100 MBPS + Real Time Monitoring Network + Remote Access',
                                    '830.000'),
                                ProductCard(
                                    'Indibiz Pijar Sekolah',
                                    'assets/images/product/6.png',
                                    'Paket internet khusus untuk sekolah dengan fitur-fitur edukatif dan konektivitas cepat. Mendukung kegiatan pembelajaran online dan digitalisasi sekolah dengan akses internet yang stabil dan cepat.',
                                    '50 MBPS + Sistem Information Management',
                                    '1.150.000',
                                    '50 MBPS + Attendance Feature',
                                    '1.230.000',
                                    '100 MBPS + Online Test + Scoring System',
                                    '1.450.000'),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: _scrollRight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String pckg1;
  final String price1;
  final String pckg2;
  final String price2;
  final String pckg3;
  final String price3;

  ProductCard(this.title, this.image, this.description, this.pckg1, this.price1,
      this.pckg2, this.price2, this.pckg3, this.price3);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: isMobile ? 150 : 300,
      height: isMobile ? 80 : 450,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            height: isMobile ? 80 : 100,
            width: double.infinity,
            child: Center(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 15 : 30.0),
          Text(
            title,
            style: TextStyle(
                fontSize: isMobile ? 12 : 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.0),
          Container(
            height: isMobile ? 80 : 150,
            width: isMobile ? double.infinity : 200,
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              description,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: isMobile ? 10 : 14),
            ),
          ),
          SizedBox(height: 8.0),
          TextButton(
            onPressed: () {
              _showProductInfoDialog(context, title, description, pckg1, price1,
                  pckg2, price2, pckg3, price3);
            },
            child: Text(
              'Info Selengkapnya',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 10 : 14),
            ),
          )
        ],
      ),
    );
  }
}

void _showProductInfoDialog(
  BuildContext context,
  String title,
  String description,
  String pckg1,
  String price1,
  String pckg2,
  String price2,
  String pckg3,
  String price3,
) {
  final bool isMobile = MediaQuery.of(context).size.width < 600;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(20.0)), // Border radius
        ),
        title: Text(title, style: TextStyle(fontSize: isMobile ? 12 : 16)),
        content: SizedBox(
          width: isMobile ? 200 : 500,
          height: isMobile ? 150 : 250,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMobile ? 12 : 16)),
                SizedBox(height: 30),
                Text("Informasi Paket Kecepatan dan Harga : ",
                    style: TextStyle(fontSize: isMobile ? 10 : 14)),
                SizedBox(height: 15),
                Text('•  $pckg1 : Rp. $price1,-',
                    style: TextStyle(fontSize: isMobile ? 10 : 14)),
                SizedBox(height: 10),
                Text('•  $pckg2 : Rp. $price2,-',
                    style: TextStyle(fontSize: isMobile ? 10 : 14)),
                SizedBox(height: 10),
                Text('•  $pckg3 : Rp. $price3,-',
                    style: TextStyle(fontSize: isMobile ? 10 : 14)),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Tutup'),
          ),
        ],
      );
    },
  );
}

class SmallImageCard extends StatelessWidget {
  final String imagePath;

  const SmallImageCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = !kIsWeb || MediaQuery.of(context).size.width < 600;

    return Container(
      height: isMobile
          ? MediaQuery.of(context).size.height *
              0.03 // Adjusted height for mobile
          : MediaQuery.of(context).size.height * 0.1,
      width: isMobile
          ? MediaQuery.of(context).size.height * 0.05
          : MediaQuery.of(context).size.height * 0.2,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(
        //   color: Colors.red,
        //   width: 0.7,
        // ),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
