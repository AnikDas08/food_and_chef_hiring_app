import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/Earning_Model.dart';

class LineChartSample2 extends StatefulWidget {
  final List<MonthEarning> chartData;
  const LineChartSample2({super.key, required this.chartData});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {

  double _normalizeValue(double value) {
    if (value <= 0) return 1;
    if (value <= 50) return 2;
    if (value <= 100) return 3;
    if (value <= 1000) return 4;
    return 5;
  }

  List<FlSpot> get spots {
    List<FlSpot> list = [];
    for (int i = 0; i < widget.chartData.length; i++) {
      list.add(FlSpot(i.toDouble(), _normalizeValue(widget.chartData[i].value)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(mainData());
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index < 0 || index >= widget.chartData.length) return const SizedBox();

    if (index % 2 != 0) return const SizedBox();

    return SideTitleWidget(
      meta: meta,
      child: Text(
        widget.chartData[index].text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          color: Color(0xff777777),
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = switch (value.toInt()) {
      1 => '0',
      2 => '50',
      3 => '100',
      4 => '1,000',
      5 => '10,000',
      _ => '',
    };
    if (text.isEmpty) return const SizedBox();
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 10,
        color: Color(0xff777777),
      ),
      textAlign: TextAlign.left,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              int index = spot.x.toInt();
              String month = index >= 0 && index < widget.chartData.length
                  ? widget.chartData[index].text
                  : '';
              double realValue = index >= 0 && index < widget.chartData.length
                  ? widget.chartData[index].value
                  : 0;
              return LineTooltipItem(
                '$month\n\$${realValue.toStringAsFixed(0)}',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (_) =>
        const FlLine(color: Color(0xffE0E0E0), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 52,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (widget.chartData.length - 1).toDouble(),
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          color: const Color(0xffFD713F),
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: 3,
                  color: const Color(0xffFD713F),
                  strokeWidth: 1.5,
                  strokeColor: Colors.white,
                ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xffFD713F).withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}