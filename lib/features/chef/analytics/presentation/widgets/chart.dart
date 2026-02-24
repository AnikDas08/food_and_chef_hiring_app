import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/Booking_Time_Model.dart';
import '../../data/Earning_Model.dart';

class _BarChart extends StatelessWidget {
  final List<MappedTime> chartData;
  const _BarChart({required this.chartData});

  int get maxCount {
    if (chartData.isEmpty) return 20;
    return chartData.map((e) => e.count).reduce((a, b) => a > b ? a : b);
  }

  int get maxIndex {
    if (chartData.isEmpty) return -1;
    int max = 0;
    for (int i = 1; i < chartData.length; i++) {
      if (chartData[i].count > chartData[max].count) max = i;
    }
    return max;
  }

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
        maxY: (maxCount * 1.3).toDouble(),
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
      getTooltipItem: (group, groupIndex, rod, rodIndex) {
        return BarTooltipItem(
          "",
          TextStyle(color: Colors.transparent),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index < 0 || index >= chartData.length) return const SizedBox();

    bool isMax = index == maxIndex;

    TextStyle style = TextStyle(
      color: isMax ? Color(0xff272727) : Color(0xff777777),
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    // প্রতি দুই বার পর পর label দেখাবে
    if (index % 2 != 0) return const SizedBox();

    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text(chartData[index].time, style: style),
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

  LinearGradient _barsGradient(int index) {
    bool isMax = index == maxIndex;
    return LinearGradient(
      colors: isMax
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
    chartData.length,
        (index) => BarChartGroupData(
      x: index,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          toY: chartData[index].count.toDouble(),
          gradient: _barsGradient(index),
          borderRadius: BorderRadius.circular(4),
          width: 18.w,
        ),
      ],
    ),
  );
}

class BarChartSample3 extends StatefulWidget {
  final List<MappedTime> chartData;
  const BarChartSample3({super.key, required this.chartData});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: _BarChart(chartData: widget.chartData),
    );
  }
}