import 'package:flutter/material.dart';
import 'package:flutter_components/components/custom_slider/progress_bar.dart';
import 'package:flutter_components/settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        appLocale = locales![1];
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          //color: Colors.amber,
          child: ProgressBar(
            barColor: Colors.blue,
            thumbColor: Colors.red,
            thumbSize: 20,
          ),
        ),
        /*DateTimeProgress(
          currentDateTime: DateTime.now().add(Duration(days: -2)),
          startDateTime: DateTime.now().add(Duration(days: -100)),
          finishDateTime: DateTime.now().add(Duration(days: 20)),
          locale: 'ru_RU',
        ),*/
      ),
    );
  }
}
