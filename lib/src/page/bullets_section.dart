import 'dart:collection';

import 'package:demoflu/src/macro.dart';
import 'package:demoflu/src/page/styled_section.dart';
import 'package:demoflu/src/provider.dart';
import 'package:flutter/material.dart';

/// Section to display bullets.
class BulletsSection extends StyledSection {
  BulletsSection(
      {required super.marginLeft,
      required super.marginBottom,
      required super.title,
      required super.padding,
      required super.background,
      required super.border,
      required super.maxWidth,
      required this.spacing}) {
    bullets = UnmodifiableListView(_bullets);
  }

  List<Bullet> _bullets = [];
  late List<Bullet> bullets;
  // How much space to place between bullets
  double spacing;

  Bullet create({int indent = 0, String? text}) {
    indent = indent < 0 ? 0 : indent;
    indent = indent > 3 ? 3 : indent;
    Bullet bullet = Bullet(indent: indent, text: text ?? '');
    _bullets.add(bullet);
    return bullet;
  }

  @override
  Widget buildContent(BuildContext context) {
    return _BulletsSectionWidget(
        bullets: bullets, spacing: spacing >= 0 ? spacing : 0);
  }

  @override
  void runMacro({required dynamic id, required BuildContext context}) {
    MacroFactory macroFactory = DemoFluProvider.macroFactoryOf(context);
    BulletsMacro macro =
        MacroFactoryHelper.getMacro<BulletsMacro>(id, 'Bullets', macroFactory);
    macro(context, this);
  }
}

class Bullet {
  Bullet({required this.indent, required String text}) : _text = text;

  final int indent;
  String _text;
  String get text => _text;

  void add(String value) {
    _text += value;
  }
}

/// Widget for bullets section.
class _BulletsSectionWidget extends StatelessWidget {
  const _BulletsSectionWidget({required this.bullets, required this.spacing});

  final List<Bullet> bullets;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < bullets.length; i++) {
      Bullet bullet = bullets[i];
      children.add(Padding(
          padding: EdgeInsets.fromLTRB(16.0 * bullet.indent, 0, 0, 0),
          child: Row(children: [
            Icon(_iconData(bullet.indent), size: 9),
            SizedBox(width: 8),
            Expanded(child: SelectableText(bullet.text))
          ], crossAxisAlignment: CrossAxisAlignment.center)));
      if (i < bullets.length - 1) {
        children.add(SizedBox(height: spacing));
      }
    }
    return Column(
        children: children, crossAxisAlignment: CrossAxisAlignment.stretch);
  }

  IconData _iconData(int indent) {
    switch (indent) {
      case 0:
        return Icons.circle_sharp;
      case 1:
        return Icons.circle_outlined;
      case 2:
        return Icons.square_sharp;
      case 3:
        return Icons.square_outlined;
      default:
        throw ArgumentError.value(indent, 'Unknown', 'indent');
    }
  }
}
