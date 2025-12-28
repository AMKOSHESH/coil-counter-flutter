import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  final List<double> values;
  final double threshold;
  final ValueChanged<double> onTap;

  const SensorChart({super.key, required this.values, required this.threshold, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const Center(child: Text('Waiting for Signal...'));

    final currentMax = values.reduce((a, b) => a > b ? a : b);
    final maxY = currentMax < 10 ? 100.0 : currentMax * 1.2;

    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox;
        final tappedValue = maxY * (1 - details.localPosition.dy / box.size.height);
        onTap(tappedValue.clamp(0, maxY));
      },
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.white10)),
          lineBarsData: [
            LineChartBarData(
              spots: values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 2,
              dotData: FlDotData(show: false),
            ),
          ],
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(y: threshold, color: Colors.redAccent, strokeWidth: 2, dashArray: [5, 5]),
            ],
          ),
        ),
      ),
    );
  }
}
