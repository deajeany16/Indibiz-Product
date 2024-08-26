import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/views/layout/footer.dart';
import 'package:webui/views/layout/top_bar.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = !kIsWeb || MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // About Section
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        // About IndiBiz Section
                        isMobile
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tentang Indibiz',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 16.0),
                                        Text(
                                          'IndiBiz adalah solusi bisnis unggulan dari Telkom yang dirancang untuk memenuhi kebutuhan beragam dari perusahaan modern. Dirancang untuk menyederhanakan operasi dan meningkatkan produktivitas, IndiBiz menawarkan rangkaian layanan terintegrasi, termasuk internet berkecepatan tinggi, solusi cloud, dan alat komunikasi canggih. Baik Anda adalah startup kecil atau korporasi besar, IndiBiz menyediakan sumber daya dan dukungan yang Anda butuhkan untuk mendorong inovasi dan mencapai tujuan bisnis Anda.',
                                          style: TextStyle(fontSize: 8),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/logo/logo.png',
                                        width: 100,
                                        height: 25,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tentang Indibiz',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20.0),
                                        Text(
                                          'IndiBiz adalah solusi bisnis unggulan dari Telkom yang dirancang untuk memenuhi \nkebutuhan beragam dari perusahaan modern. Dirancang untuk menyederhanakan operasi \ndan meningkatkan produktivitas, IndiBiz menawarkan rangkaian layanan \nterintegrasi, termasuk internet berkecepatan tinggi, solusi cloud, dan alat komunikasi canggih. \nBaik Anda adalah startup kecil atau korporasi besar, IndiBiz menyediakan sumber daya dan \ndukungan yang Anda butuhkan untuk mendorong inovasi dan mencapai tujuan bisnis Anda.',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.justify,
                                        ),
                                        SizedBox(height: 25.0),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/logo/logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 30.0),
                        // About Telkom Section
                        isMobile
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Center(
                                    child: Image.asset(
                                      'assets/images/telkom.jpg',
                                      width: 80,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tentang Telkom',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 16.0),
                                        Text(
                                          'Telkom Indonesia, perusahaan telekomunikasi terkemuka, telah berada di garis depan transformasi digital Indonesia selama beberapa dekade. Dengan warisan inovasi dan komitmen untuk meningkatkan konektivitas, Telkom Indonesia menawarkan berbagai layanan komprehensif, termasuk telekomunikasi tetap dan seluler, internet broadband, dan solusi digital. Infrastruktur yang kuat dan teknologi canggih mereka memberdayakan bisnis dan individu untuk tetap terhubung, efisien, dan kompetitif di dunia yang bergerak cepat saat ini.',
                                          style: TextStyle(fontSize: 8),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/telkom.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tentang Telkom',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20.0),
                                        Text(
                                          'Telkom Indonesia, perusahaan telekomunikasi terkemuka, telah berada di garis \ndepan transformasi digital Indonesia selama beberapa dekade. Dengan warisan \ninovasi dan komitmen untuk meningkatkan konektivitas, Telkom Indonesia \nmenawarkan berbagai layanan komprehensif, termasuk telekomunikasi \ntetap dan seluler, internet broadband, dan solusi digital. Infrastruktur yang kuat \ndan teknologi canggih mereka memberdayakan bisnis dan individu untuk tetap \nterhubung, efisien, dan kompetitif di dunia yang bergerak cepat saat ini.',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: isMobile
                        ? const EdgeInsets.only(top: 15, left: 8, right: 8)
                        : const EdgeInsets.symmetric(vertical: 25.0),
                    child: Column(
                      children: [
                        Text(
                          'Segera daftarkan bisnis kamu untuk berlangganan Indibiz!',
                          style: TextStyle(
                              fontSize: isMobile ? 14 : 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30.0),
                        isMobile
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset(
                                      'assets/images/admin.png',
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 16.0),
                                        Text(
                                          'Hubungi :',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text('Instagram : @indibiz.kalteng',
                                            style: TextStyle(fontSize: 10)),
                                        SizedBox(height: 8),
                                        Text('Twitter : @indibiz.kalteng',
                                            style: TextStyle(fontSize: 10)),
                                        SizedBox(height: 8),
                                        Text('Email : indibizkalteng@gmail.com',
                                            style: TextStyle(fontSize: 10)),
                                        SizedBox(height: 8),
                                        Text('Nomor Telepon : 080808080808',
                                            style: TextStyle(fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Hubungi :',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text('Instagram : @indibiz.kalteng'),
                                        SizedBox(height: 8),
                                        Text('Twitter : @indibiz.kalteng'),
                                        SizedBox(height: 8),
                                        Text(
                                            'Email : indibizkalteng@gmail.com'),
                                        SizedBox(height: 8),
                                        Text('Nomor Telepon : 080808080808'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Container(
                                    width: 300,
                                    height: 300,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/admin.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 30.0),
                        isMobile
                            ? Padding(
                                padding: const EdgeInsets.all(
                                    16.0), // Atur padding sesuai kebutuhan Anda
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Kantor Telkom Palangka Raya',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text('JL. Ahmad Yani No. 45',
                                              style: TextStyle(fontSize: 10)),
                                          SizedBox(height: 4),
                                          Text('Kelurahan Pahandut',
                                              style: TextStyle(fontSize: 10)),
                                          SizedBox(height: 4),
                                          Text('Kecamatan Pahandut',
                                              style: TextStyle(fontSize: 10)),
                                          SizedBox(height: 4),
                                          Text('Kota Palangka Raya',
                                              style: TextStyle(fontSize: 10)),
                                          SizedBox(height: 4),
                                          Text('Kalimantan Tengah',
                                              style: TextStyle(fontSize: 10)),
                                          SizedBox(height: 4),
                                          Text('Kode Pos 73111',
                                              style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      flex: 2,
                                      child: Image.asset(
                                        'assets/images/office.png',
                                        width: 200,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 500,
                                    height: 300,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/office.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Kantor Telkom Palangka Raya',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text('JL. Ahmad Yani No. 45'),
                                        SizedBox(height: 8),
                                        Text('Kelurahan Pahandut'),
                                        SizedBox(height: 8),
                                        Text('Kecamatan Pahandut'),
                                        SizedBox(height: 8),
                                        Text('Kota Palangka Raya'),
                                        SizedBox(height: 8),
                                        Text('Kalimantan Tengah'),
                                        SizedBox(height: 8),
                                        Text('Kode Pos 73111'),
                                      ],
                                    ),
                                  ),
                                ],
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
