import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  final List<double> values;
  final double threshold;
  final ValueChanged<double> onTap;

  const SensorChart({super.key, required this.values, required this.threshold, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox;
        final tappedValue = 1000 * (1 - details.localPosition.dy / box.size.height);
        onTap(tappedValue.clamp(0, 1000));
      },
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 1000, // محور عمودی روی ۱۰۰۰ فیکس شد
          gridData: FlGridData(show: true, horizontalInterval: 200),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: Colors.blue,
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
