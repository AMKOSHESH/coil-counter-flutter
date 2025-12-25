import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  final List<double> values;
  final double threshold;
  final void Function(double) onTap;

  const SensorChart({
    super.key,
    required this.values,
    required this.threshold,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 200,
        lineTouchData: LineTouchData(
          touchCallback: (event, response) {
            if (event is FlTapUpEvent &&
                response?.lineBarSpots?.isNotEmpty == true) {
              onTap(response!.lineBarSpots!.first.y);
            }
          },
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(y: threshold, dashArray: [5, 5]),
          ],
        ),
        titlesData: FlTitlesData(
          bottomTitles:
              AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: false,
            dotData: FlDotData(show: false),
            spots: values
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
          ),
        ],
      ),
    );
  }
}
