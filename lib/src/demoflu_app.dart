import 'package:demoflu/src/example/example_widget.dart';
import 'package:demoflu/src/example.dart';
import 'package:demoflu/src/section.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _url = 'https://flutter.dev';

class DemoFluApp extends StatefulWidget {
  const DemoFluApp({required this.title, required this.sections});

  final String title;
  final List<DFSection> sections;

  @override
  State<StatefulWidget> createState() => DemoFluAppState();
}

class DemoFluMenuItem {
  DemoFluMenuItem(this.sectionName, this.example);

  final String? sectionName;
  final DFExample example;
}

class DemoFluAppState extends State<DemoFluApp> {
  DemoFluMenuItem? _currentMenuItem;

  DemoFluMenuItem? get currentMenuItem => _currentMenuItem;

  @override
  void initState() {
    super.initState();
    if (widget.sections.isNotEmpty) {
      DFSection section = widget.sections.first;
      if (section.examples.isNotEmpty) {
        _currentMenuItem =
            DemoFluMenuItem(section.name, section.examples.first);
      }
    }
  }

  void updateFor(String? sectionName, DFExample example) async {
    String? code;
    if (example.codeFile != null) {
      code = await rootBundle.loadString(example.codeFile!);
      print(code);
    }
    setState(() {
      _currentMenuItem = DemoFluMenuItem(sectionName, example);
    });
  }

  List<DFSection> get sections => widget.sections;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: widget.title,
        theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: Colors.white),
        home: Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
                backgroundColor: Colors.blueGrey[900],
                actions: [_DemoFluLogo()]),
            body:
                _DemoFluAppInheritedWidget(state: this, child: ExampleBody())));
  }

  static DemoFluAppState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_DemoFluAppInheritedWidget>()
        ?.state;
  }
}

class _DemoFluAppInheritedWidget extends InheritedWidget {
  _DemoFluAppInheritedWidget({required this.state, required Widget child})
      : super(child: child);

  final DemoFluAppState state;

  @override
  bool updateShouldNotify(covariant _DemoFluAppInheritedWidget oldWidget) =>
      true;
}

class _DemoFluLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Column column = Column(children: [
      Text('built with', style: TextStyle(fontSize: 12)),
      Text('DemoFlu', style: TextStyle(fontSize: 14))
    ], mainAxisAlignment: MainAxisAlignment.center);
    FittedBox fittedBox = FittedBox(child: column, fit: BoxFit.scaleDown);
    EdgeInsets padding = EdgeInsets.fromLTRB(16, 8, 16, 8);
    Container container = Container(child: fittedBox, padding: padding);
    return InkWell(
        child: LimitedBox(child: container, maxHeight: kToolbarHeight),
        onTap: () => _launchURL());
  }

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
