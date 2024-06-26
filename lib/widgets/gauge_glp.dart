import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeGlp extends StatelessWidget {
  final double value;

  const GaugeGlp({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    Widget progressBar;

    if (value >= 0 && value <= 33.3) {
      progressBar = AnimatedRadialGauge(
        duration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        radius: 100,
        value: value,
        axis: const GaugeAxis(
          min: 0,
          max: 100,
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
              to: 33.3,
              color: Color(0xFFD9DEEB),
              cornerRadius: Radius.zero,
            ),
          ],
        ),
      );
    } else if (value > 33.3 && value <= 66.6) {
      progressBar = AnimatedRadialGauge(
        duration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        radius: 100,
        value: value,
        axis: const GaugeAxis(
          min: 0,
          max: 100,
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
            color: Colors.yellow,
          ),
          segments: [
            GaugeSegment(
              from: 0,
              to: 33.3,
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
        value: value, // Ajusta el valor para el tercer segmento
        axis: const GaugeAxis(
          min: 0,
          max: 100, // Ajusta el máximo para el tercer segmento
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
              to: 33.4, // Ajusta el límite superior para el tercer segmento
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
