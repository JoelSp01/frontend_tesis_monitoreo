import 'package:flutter/material.dart';

import '../widgets/gauge_glp_widget.dart';
import '../widgets/gauge_temp_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF07328),
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          title: Center(
            child: Image.asset(
              'img/logoAlphaSinFondo.png',
              width: 70,
              height: 70,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF07328),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GaugeGlpWidget(),
            /* Gauge TEMPERATURA */
            GaugeTempWidget(),
          ],
        ),
      );
  }
}