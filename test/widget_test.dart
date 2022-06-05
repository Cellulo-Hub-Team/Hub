// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:cellulo_hub/custom_widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cellulo_hub/main.dart';

void main() {

  testWidgets('My Games button goes to MyGames', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(skipWelcome: true));
    await tester.pump();

    expect(find.byIcon(FontAwesome.gamepad), findsOneWidget);
    expect(find.byIcon(Entypo.shop), findsOneWidget);
    expect(find.byIcon(MaterialCommunityIcons.medal), findsOneWidget);
    expect(find.byIcon(MaterialCommunityIcons.lightbulb_on), findsOneWidget);
    expect(find.byIcon(Ionicons.ios_settings), findsOneWidget);

    await tester.tap(find.byIcon(FontAwesome.gamepad));
    await tester.pump();

    //expect(find.byIcon(Icons.home), findsOneWidget);
  });
}
