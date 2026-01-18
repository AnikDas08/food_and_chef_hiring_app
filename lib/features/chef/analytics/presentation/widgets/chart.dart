import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final List<int> _items = [3, 5, 7, 9, 11, 13, 15, 13, 11, 9, 7, 5, 3];

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        barTouchData: barTouchData,
        maxY: 20,
        groupsSpace: 1,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: true,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
        BarChartGroupData group,
        int groupIndex,
        BarChartRodData rod,
        int rodIndex,
      ) {
        return BarTooltipItem(
          "",
          TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: Color(0xff777777),
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
    String text = "";
    switch (value.toInt()) {
      case 0:
        text = "6pm";
      case 3:
        text = "8pm";
      case 6:
        text = "10pm";
        style = TextStyle(
          color: Color(0xff272727),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        );
      case 9:
        text = "12pm";
      case 12:
        text = "14pm";
    }
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: 1,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );

  FlBorderData get borderData => FlBorderData(show: false);

  LinearGradient _barsGradient(num value) {
    return LinearGradient(
      colors:
          value % 15 == 0
              ? [Color(0xffFD713F), Color(0xffFD713F)]
              : [
                Color(0xffFD713F).withValues(alpha: 0.24),
                Color(0xffFD713F).withValues(alpha: 0.24),
              ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }

  List<BarChartGroupData> get barGroups => List.generate(
    _items.length,
    (index) => BarChartGroupData(
      x: index,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          toY: _items[index].toDouble(),
          gradient: _barsGradient(_items[index]),
          borderRadius: BorderRadius.circular(4),
          width: 18.w,
        ),
      ],
    ),
  );
}

class BarChartSample3 extends StatefulWidget {
  const BarChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return const AspectRatio(aspectRatio: 1.6, child: _BarChart());
  }
}
