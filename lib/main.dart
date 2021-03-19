import 'package:flutter/material.dart';
import 'package:flutter_components/settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'components/date_time_progress/date_time_progress.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        appLocale = locales![0];
        return appLocale;
      },
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: Center(
        child: Container(
          width: 300,
          //color: Colors.amber,
          child: DateTimeProgress(
            current: DateTime.now().add(Duration(days: -2)),
            start: DateTime.now().add(Duration(days: -10)),
            finish: DateTime.now().add(Duration(days: 20)),
            onChangeStart: (startDateTime) {
              print('onChangeStart $startDateTime');
            },
            onChangeFinish: (finishDateTime) {
              print('onChangeFinish $finishDateTime');
            },
          ),
        ),
      ),
    );
  }
}
