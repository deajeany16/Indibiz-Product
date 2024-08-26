import 'package:get/get.dart';
import 'package:webui/views/aboutus_screen.dart';
import 'package:webui/views/cekjaringan_screen.dart';
import 'package:webui/views/home_screen.dart';

getPageRoute() {
  var routes = [
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
    ),
    GetPage(
      name: '/cekjaringan',
      page: () => CekJaringanScreen(),
    ),
    GetPage(
      name: '/aboutus',
      page: () => AboutUsScreen(),
    ),
  ];
  return routes
      .map((e) => GetPage(
          name: e.name,
          page: e.page,
          middlewares: e.middlewares,
          transition: Transition.noTransition))
      .toList();
}