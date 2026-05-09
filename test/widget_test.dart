import 'package:chalk_it_up/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Setup Screen', () {
    testWidgets('displays setup screen on launch', (tester) async {
      await tester.pumpWidget(const ChalkItUpApp());
      expect(find.text('New Match'), findsOneWidget);
      expect(find.text('9-Ball'), findsOneWidget);
      expect(find.text('Start Match'), findsOneWidget);
    });

    testWidgets('shows error when player name(s) is blank', (tester) async {
      await tester.pumpWidget(const ChalkItUpApp());
      await tester.tap(find.text('Start Match'));
      await tester.pump();
      expect(find.text('Please enter both player names'), findsOneWidget);
    });

    testWidgets('shows error when race length is out of range', (tester) async {
      await tester.pumpWidget(const ChalkItUpApp());
      await tester.enterText(find.byType(TextField).at(0), 'Allen');
      await tester.enterText(find.byType(TextField).at(1), 'Melanie');
      await tester.enterText(find.byType(TextField).at(2), '25');
      await tester.tap(find.text('Start Match'));
      await tester.pump();
      expect(find.text('Race length must be between 1 and 20'), findsOneWidget);
    });

    testWidgets('navigates to match screen when valid data entered', (
      tester,
    ) async {
      await tester.pumpWidget(const ChalkItUpApp());
      await tester.enterText(find.byType(TextField).at(0), 'Allen');
      await tester.enterText(find.byType(TextField).at(1), 'Melanie');
      await tester.enterText(find.byType(TextField).at(2), '7');
      await tester.tap(find.text('Start Match'));
      await tester.pumpAndSettle();
      expect(find.text('Tap to score'), findsWidgets);
      expect(find.text('9-Ball • Race to 7'), findsOneWidget);
    });
  });

  group('Match Screen', () {
    Future<void> startMatch(WidgetTester tester, {int race = 3}) async {
      await tester.pumpWidget(const ChalkItUpApp());
      await tester.enterText(find.byType(TextField).at(0), 'Allen');
      await tester.enterText(find.byType(TextField).at(1), 'Melanie');
      await tester.enterText(find.byType(TextField).at(2), '$race');
      await tester.tap(find.text('Start Match'));
      await tester.pumpAndSettle();
    }

    testWidgets('tapping player score increments score', (tester) async {
      await startMatch(tester);
      await tester.tap(find.text('Allen').first);
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('long press on score undoes last point', (tester) async {
      await startMatch(tester);
      await tester.tap(find.text('Allen').first);
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
      await tester.longPress(find.text('1'));
      await tester.pump();
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('tapping inning increments innings', (tester) async {
      await startMatch(tester);
      expect(find.text('Innings: 0'), findsOneWidget);
      await tester.tap(find.text('Inning'));
      await tester.pump();
      expect(find.text('Innings: 1'), findsOneWidget);
    });

    testWidgets('selecting break highlights player name', (tester) async {
      await startMatch(tester);
      await tester.tap(find.text('Allen').last);
      await tester.pump();
      expect(find.text('Allen'), findsWidgets);
    });

    testWidgets('winner banner displays when race is reached', (tester) async {
      await startMatch(tester, race: 1);
      await tester.tap(find.text('Allen').first);
      await tester.pump();
      expect(find.text('🏆 Allen wins!'), findsOneWidget);
      expect(find.text('Generate Trash Talk'), findsOneWidget);
      expect(find.text('New Match'), findsOneWidget);
    });

    testWidgets('new match button returns to setup screen', (tester) async {
      await startMatch(tester, race: 1);
      await tester.tap(find.text('Allen').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('New Match'));
      await tester.pumpAndSettle();
      expect(find.text('New Match'), findsOneWidget);
      expect(find.text('Start Match'), findsOneWidget);
    });
  });

  group('Match Locked State', () {
    Future<void> completeMatch(WidgetTester tester) async {
      await tester.pumpWidget(const ChalkItUpApp());
      await tester.enterText(find.byType(TextField).at(0), 'Allen');
      await tester.enterText(find.byType(TextField).at(1), 'Melanie');
      await tester.enterText(find.byType(TextField).at(2), '1');
      await tester.tap(find.text('Start Match'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Allen').first);
      await tester.pump();
    }

    testWidgets('score does not increase after match is complete', (
      tester,
    ) async {
      await completeMatch(tester);
      expect(find.text('1'), findsOneWidget);
      await tester.tap(find.text('1'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('innings do not increase after match is complete', (
      tester,
    ) async {
      await completeMatch(tester);
      expect(find.text('Innings: 0'), findsOneWidget);
      await tester.tap(find.text('Inning'));
      await tester.pump();
      expect(find.text('Innings: 0'), findsOneWidget);
    });
  });
}
