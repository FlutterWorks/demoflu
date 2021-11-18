import 'package:demoflu/demoflu.dart';
import 'package:demoflu_example/example1.dart';
import 'package:demoflu_example/example2.dart';
import 'package:demoflu_example/example3.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DemoFluApp(
      initialHeightWeight: .5,
      title: 'Example Demo',
      appMenuBuilder: () {
        return [
          MenuItem(name: 'Section', italic: true),
          MenuItem(
              name: 'Example 1',
              builder: (settings)=>Example1(),
              codeFile: 'lib/example1.dart',
              resizable: true,
              indentation: 2),
          MenuItem(
              name: 'Example 2',
              builder: (settings)=>Example2(),
              codeFile: 'lib/example2.dart',
              consoleEnabled: true,
              indentation: 2),
          MenuItem(name: 'Example 3',
              builder: (settings)=>Example3(), indentation: 2)
        ];
      }));
}
