import 'package:flutter/material.dart';
import 'package:flutter_components/components/date_time_progress/custom_thumb_shape.dart';
import 'package:flutter_components/components/date_time_progress/custom_value_indicator_shape.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeProgress extends StatefulWidget {
  final DateTime startDateTime;
  final DateTime finishDateTime;
  final DateTime currentDateTime;
  final int divisions;
  final String locale;
  final String typeDateFormate;

  DateTimeProgress({
    @required this.startDateTime,
    @required this.finishDateTime,
    @required this.currentDateTime,
    this.divisions = 10,
    this.locale = 'en_US',
    this.typeDateFormate = DateFormat.YEAR_NUM_MONTH_DAY,
  });

  @override
  _DateTimeProgressState createState() => _DateTimeProgressState();
}

class _DateTimeProgressState extends State<DateTimeProgress> {
  DateTime _currentDateTime;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _currentDateTime = widget.currentDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SliderTheme(
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
          value:
              double.parse(_currentDateTime.microsecondsSinceEpoch.toString()),
          min: double.parse(
              widget.startDateTime.microsecondsSinceEpoch.toString()),
          max: double.parse(
              widget.finishDateTime.microsecondsSinceEpoch.toString()),
          divisions: widget.divisions,
          semanticFormatterCallback: (value) => value.round().toString(),
          label: _formateDate(widget.currentDateTime),
          onChanged: null,
        ),
      ),
    );
  }

  String _formateDate(DateTime dateTime) {
    var dateFormat = DateFormat(widget.typeDateFormate, widget.locale);
    return dateFormat.format(dateTime);
  }
}
