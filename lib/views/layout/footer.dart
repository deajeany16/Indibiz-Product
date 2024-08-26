// lib/widgets/footer.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bool isMobile = !kIsWeb || MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.red,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '© 2024 Telkom Palangkaraya. All rights reserved.',
                      style: TextStyle(color: Colors.white, fontSize: isMobile ? 10 : 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
