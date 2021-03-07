import 'package:flutter/material.dart';
import 'package:flutter_components/components/date_time_progress/custom_thumb_shape.dart';
import 'package:flutter_components/components/date_time_progress/custom_value_indicator_shape.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DateTimeProgress extends StatefulWidget {
  final DateTime startDateTime;
  final DateTime finishDateTime;
  final DateTime currentDateTime;
  final String locale;
  final String typeDateFormate;

  DateTimeProgress({
    @required this.startDateTime,
    @required this.finishDateTime,
    @required this.currentDateTime,
    this.locale = 'en_US',
    this.typeDateFormate = DateFormat.YEAR_NUM_MONTH_DAY,
  });

  @override
  _DateTimeProgressState createState() => _DateTimeProgressState();
}

class _DateTimeProgressState extends State<DateTimeProgress> {
  DateTime _currentDateTime;
  double _currentValue;
  int _durationDateTime;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _currentDateTime = widget.currentDateTime;
    _durationDateTime = widget.finishDateTime.microsecondsSinceEpoch -
        widget.startDateTime.microsecondsSinceEpoch;
    _currentValue = (_currentDateTime.microsecondsSinceEpoch -
            widget.startDateTime.microsecondsSinceEpoch) /
        _durationDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SfSlider(
          min: DateTime.now().add(Duration(days: -10)),
          max: DateTime.now().add(Duration(days: 10)),
          value: _currentDateTime,
          onChanged: (value) {
            setState(() {
              _currentDateTime = value;
            });
          },
          dateIntervalType: DateIntervalType.days,
          showLabels: true,
          showTicks: true,
          dateFormat: DateFormat.yMMMMd(),
          enableTooltip: true,
        ) /*SliderTheme(
        data: theme.sliderTheme.copyWith(
          trackHeight: 2,
          disabledActiveTrackColor: theme.accentColor,
          disabledInactiveTrackColor: theme.accentColor.withOpacity(.7),
          disabledThumbColor: theme.accentColor.withOpacity(.8),
          thumbShape: const CustomThumbShape(),
          valueIndicatorShape: const CustomValueIndicatorShape(),
          valueIndicatorTextStyle: theme.accentTextTheme.bodyText1
              .copyWith(color: theme.colorScheme.onSurface),
              
        ),
        child: Slider(
          value: _currentValue,
          label: _formateDate(doubleToDateTime(_currentValue)),
          onChanged: null,
        ),
      ),*/
        );
  }

  DateTime doubleToDateTime(double value) {
    var microsecondsSinceEpoch = widget.startDateTime.microsecondsSinceEpoch +
        (_durationDateTime * value).round();
    var dateTime = DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);
    return dateTime;
  }

  String _formateDate(DateTime dateTime) {
    var dateFormat = DateFormat(widget.typeDateFormate, widget.locale);
    return dateFormat.format(dateTime);
  }
}
