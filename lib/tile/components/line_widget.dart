import 'package:atom/gen/colors.gen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineWidget extends StatefulWidget {
  const LineWidget({
    super.key,
    required this.value,
    required this.unit,
  });

  final String value;
  final String? unit;

  @override
  State<LineWidget> createState() => _LineWidgetState();
}

class _LineWidgetState extends State<LineWidget> {
  final maxLength = 10;
  // values for build chart
  List<double> _values = [];
  // whether latest value is greater or smaller than previous
  bool? _isUpTrend;
  // the deviant of latest and previous in percent
  double? _deviant;
  // unit of chart
  late bool _shouldUpdate;

  @override
  void initState() {
    super.initState();
    _shouldUpdate = true;
    _updateValue(widget.value);
    setState(() {
      _shouldUpdate = false;
    });
  }

  void _updateValue(String latestValue) {
    if (double.tryParse(latestValue) != null && _shouldUpdate) {
      final latestValueDouble = double.parse(latestValue);
      final values = List<double>.from(_values);
      if (values.isNotEmpty) {
        final lastValue = values.last;
        // update trend
        setState(() {
          _isUpTrend = latestValueDouble > lastValue;
          _deviant = (latestValueDouble - lastValue).abs() / lastValue * 100;
        });
        // keep values length is not exceed max
        if (values.length == maxLength) {
          values.removeAt(0);
        }
        values.add(latestValueDouble);
        setState(() {
          _values = values;
        });
      } else {
        // values is empty
        values.add(latestValueDouble);
        setState(() {
          _values = values;
        });
      }
    }
  }

  @override
  void didUpdateWidget(LineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldUpdate) {
      _updateValue(widget.value);
    } else {
      setState(() {
        _shouldUpdate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2.5,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final width = constraints.maxWidth;
              final paddingHorizontal = width * 0.05;
              final paddingVertical = height * 0.15;
              // get latest value
              final value =
                  _values.isNotEmpty ? _values.last.toString() : '...';
              // get trend indicator
              IconData? iconData;
              Color? trendColor;
              if (_isUpTrend != null) {
                if (_isUpTrend!) {
                  iconData = Icons.arrow_upward;
                  trendColor = ColorName.gGreen;
                } else {
                  iconData = Icons.arrow_downward;
                  trendColor = ColorName.XRed;
                }
              }
              // get percent devian
              String? percentDeviant;
              if (_deviant != null) {
                percentDeviant = _deviant!.toStringAsFixed(1);
              }
              return Container(
                padding: EdgeInsets.symmetric(
                  vertical: paddingVertical,
                  horizontal: paddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        if (widget.unit != null)
                          Text('$value ${widget.unit}',
                              style: textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorName.neural700,
                              ))
                        else
                          Text(
                            value,
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorName.neural700,
                            ),
                          ),
                        if (iconData != null) Icon(iconData),
                        if (percentDeviant != null)
                          Text(
                            '$percentDeviant %',
                            style: textTheme.titleSmall!.copyWith(
                              color: trendColor,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        AspectRatio(
          aspectRatio: 2.5,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final width = constraints.maxWidth;
              final paddingHorizontal = width * 0.05;
              final paddingVertical = height * 0.15;
              return Container(
                padding: EdgeInsets.symmetric(
                  vertical: paddingVertical,
                  horizontal: paddingHorizontal,
                ),
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 10,
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        color: ColorName.XBlack,
                        spots: List.generate(
                          _values.length,
                          (index) => FlSpot(index.toDouble(), _values[index]),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
