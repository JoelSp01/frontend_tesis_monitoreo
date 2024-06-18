import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeTemperature extends StatelessWidget {
  final double value;

  const GaugeTemperature({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    Widget progressBar;

    if (value >= 0 && value <= 13) {
      progressBar = AnimatedRadialGauge(
        duration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        radius: 100,
        value: value,
        axis: const GaugeAxis(
          min: 0,
          max: 40, // Ajusta el máximo aquí
          degrees: 180,
          style: GaugeAxisStyle(
            thickness: 20,
            background: Color(0xFFDFE2EC),
            segmentSpacing: 4,
          ),
          pointer: GaugePointer.needle(
            width: 20,
            height: 100,
            color: Color(0xFFB4C2F8),
          ),
          progressBar: GaugeProgressBar.rounded(
            color: Colors.blue,
          ),
          segments: [
            GaugeSegment(
              from: 0,
              to: 13.3, // Ajusta el límite superior para el primer segmento
              color: Color(0xFFD9DEEB),
              cornerRadius: Radius.zero,
            ),
          ],
        ),
      );
    } else if (value > 13 && value <= 23) {
      progressBar = AnimatedRadialGauge(
        duration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        radius: 100,
        value: value,
        axis: const GaugeAxis(
          min: 0,
          max: 40, // Ajusta el máximo aquí
          degrees: 180,
          style: GaugeAxisStyle(
            thickness: 20,
            background: Color(0xFFDFE2EC),
            segmentSpacing: 4,
          ),
          pointer: GaugePointer.needle(
            width: 20,
            height: 100,
            color: Color(0xFFB4C2F8),
          ),
          progressBar: GaugeProgressBar.rounded(
            color: Colors.green,
          ),
          segments: [
            GaugeSegment(
              from: 0,
              to: 23.3, // Ajusta el límite superior para el segundo segmento
              color: Color(0xFFD9DEEB),
              cornerRadius: Radius.zero,
            ),
          ],
        ),
      );
    } else {
      progressBar = AnimatedRadialGauge(
        duration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        radius: 100,
        value: value,
        axis: const GaugeAxis(
          min: 0,
          max: 40, // Ajusta el máximo aquí
          degrees: 180,
          style: GaugeAxisStyle(
            thickness: 20,
            background: Color(0xFFDFE2EC),
            segmentSpacing: 4,
          ),
          pointer: GaugePointer.needle(
            width: 20,
            height: 100,
            color: Color(0xFFB4C2F8),
          ),
          progressBar: GaugeProgressBar.rounded(
            color: Colors.red,
          ),
          segments: [
            GaugeSegment(
              from: 0,
              to: 40, // Ajusta el límite superior para el tercer segmento
              color: Color(0xFFD9DEEB),
              cornerRadius: Radius.zero,
            ),
          ],
        ),
      );
    }

    return progressBar;
  }
}
