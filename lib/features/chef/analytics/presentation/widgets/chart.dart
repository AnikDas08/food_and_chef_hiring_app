import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/Booking_Time_Model.dart';

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
        return BarTooltipItem('', const TextStyle(color: Colors.transparent));
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final int index = value.toInt();
    if (index < 0 || index >= chartData.length) return const SizedBox();
    final bool isMax = index == maxIndex;
    final TextStyle style = TextStyle(
      color: isMax ? const Color(0xff272727) : const Color(0xff777777),
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );
    if (index % 2 != 0) return const SizedBox();
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text(chartData[index].time, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: 1,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(),
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
  );

  FlBorderData get borderData => FlBorderData(show: false);

  LinearGradient _barsGradient(int index) {
    final bool isMax = index == maxIndex;
    return LinearGradient(
      colors: isMax
          ? [const Color(0xffFD713F), const Color(0xffFD713F)]
          : [
        const Color(0xffFD713F).withValues(alpha: 0.24),
        const Color(0xffFD713F).withValues(alpha: 0.24),
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

class BarChartSample3 extends StatelessWidget {
  final List<MappedTime> chartData;
  const BarChartSample3({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return _BarChart(chartData: chartData);
  }
}