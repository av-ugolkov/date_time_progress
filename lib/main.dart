import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'components/date_time_progress/date_time_progress.dart';
import 'util/extension.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DateTime _current;
  late DateTime _start;
  late DateTime _finish;

  late TapGestureRecognizer _tap;

  @override
  void initState() {
    _current = DateTime.now().getDate();
    _start = DateTime.now().add(Duration(days: -3)).getDate();
    _finish = DateTime.now().add(Duration(days: 3)).getDate();

    _tap = TapGestureRecognizer()..onTap = _onTap;
    super.initState();
  }

  void _onTap() {
    var initTap = _tap.initialPosition;
    print(initTap?.global);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DateTimeProgress(
                current: _current,
                start: _start,
                finish: _finish,
                roundingDate: true,
                dateFormatePattern: 'dd.MM.yy_HH:ss',
                onChangeStart: (dateTime) async {
                  var datePicker = await showDatePicker(
                      context: context,
                      initialDate: dateTime,
                      firstDate: DateTime(0),
                      lastDate: _finish);
                  setState(() {
                    _start = datePicker ?? _start;
                  });
                },
                onChangeFinish: (dateTime) async {
                  var datePicker = await showDatePicker(
                      context: context,
                      initialDate: dateTime,
                      firstDate: _finish,
                      lastDate: DateTime(9999));
                  setState(() {
                    _finish = datePicker ?? _finish;
                  });
                },
                onChange: (dateTime) {
                  print(dateTime);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
