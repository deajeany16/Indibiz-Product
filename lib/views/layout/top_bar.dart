import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webui/helper/utils/my_shadow.dart';
import 'package:webui/helper/utils/ui_mixins.dart';
import 'package:webui/helper/widgets/my_card.dart';
import 'package:webui/helper/widgets/my_spacing.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar>
    with SingleTickerProviderStateMixin, UIMixin {
  final RxInt _activeButtonIndex = 0.obs;
  final RxBool _isMenuVisible = false.obs; // Control menu visibility

  @override
  void initState() {
    super.initState();
    _updateActiveButtonIndex(Get.currentRoute);
    ever(Get.currentRoute.obs, _updateActiveButtonIndex);
  }

  void _updateActiveButtonIndex(String route) {
    switch (route) {
      case '/home':
        _activeButtonIndex.value = 0;
        break;
      case '/cekjaringan':
        _activeButtonIndex.value = 1;
        break;
      case '/aboutus':
        _activeButtonIndex.value = 2;
        break;
      default:
        _activeButtonIndex.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyCard(
          shadow:
              MyShadow(position: MyShadowPosition.bottomRight, elevation: 0.5),
          height: 80,
          borderRadiusAll: 0,
          padding: MySpacing.x(24),
          color: topBarTheme.background.withAlpha(246),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile view with burger menu on the left and logo in the center
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/logo/logo.png',
                              height: 30,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                _isMenuVisible
                                    .toggle(); // Toggle menu visibility
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else {
                // Desktop view with full navigation
                return Row(
                  children: [
                    Image.asset(
                      'assets/images/logo/logo.png',
                      height: 40,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildNavBox('Product', '/home', 0),
                          _buildNavBox(
                              'Cek Jaringan Disekitarmu', '/cekjaringan', 1),
                          _buildNavBox('About Us', '/aboutus', 2),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        // Display the menu options below the top bar when visible
        Obx(
          () => Visibility(
            visible: _isMenuVisible.value,
            child: Column(
              children: [
                _buildNavItem('Product', '/home', 0),
                _buildNavItem('Cek Jaringan Disekitarmu', '/cekjaringan', 1),
                _buildNavItem('About Us', '/aboutus', 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavBox(String text, String route, int index) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return Obx(
      () => InkWell(
        onTap: () {
          Get.toNamed(route);
          _activeButtonIndex.value = index;
        },
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: isMobile ? 6 : 15),
          padding:
              EdgeInsets.symmetric(horizontal: 24, vertical: isMobile ? 6 : 10),
          decoration: BoxDecoration(
            color: _activeButtonIndex.value == index
                ? Colors.red
                : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: _activeButtonIndex.value == index
                    ? Colors.white
                    : Colors.black,
                fontSize: isMobile ? 10 : 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String text, String route, int index) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontSize: isMobile ? 10 : 16,
        ),
      ),
      onTap: () {
        Get.toNamed(route);
        _activeButtonIndex.value = index;
        _isMenuVisible.value = false; // Hide the menu after selection
      },
    );
  }
}
