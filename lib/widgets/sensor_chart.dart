import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  final List<double> values;
  final double threshold;
  final ValueChanged<double> onTap;

  const SensorChart({
    super.key,
    required this.values,
    required this.threshold,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Center(child: Text('No signal'));
    }

    final maxY = values.reduce((a, b) => a > b ? a : b) * 1.1;

    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox;
        final dy = details.localPosition.dy;
        final height = box.size.height;

        final tappedValue = maxY * (1 - dy / height);
        onTap(tappedValue.clamp(0, maxY));
      },
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: values
                  .asMap()
                  .entries
                  .map((e) =>
                      FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: false,
              barWidth: 2,
              dotData: FlDotData(show: false),
            ),
          ],
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: threshold,
                color: Colors.red,
                strokeWidth: 2,
                dashArray: [6, 4],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
