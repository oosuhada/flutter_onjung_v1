import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('core Onjung journey stays navigable in demo mode', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('이번 달 온정 흐름'), findsOneWidget);
    expect(find.text('최근 온정'), findsOneWidget);

    await tester.tap(find.text('온정록'));
    await tester.pumpAndSettle();
    expect(find.text('5개의 기록'), findsOneWidget);

    await tester.tap(find.byKey(const Key('record-r1')));
    await tester.pumpAndSettle();
    expect(find.text('온정 상세'), findsOneWidget);
    expect(find.text('김서연'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quick-record-fab')));
    await tester.pumpAndSettle();
    expect(find.text('빠른 온정 기록'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('save-record-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('save-record-button')));
    await tester.pumpAndSettle();
    expect(find.text('6개의 기록'), findsOneWidget);
    expect(find.text('한소희'), findsOneWidget);

    await tester.tap(find.text('내 온정'));
    await tester.pumpAndSettle();
    expect(find.text('관계 인사이트'), findsOneWidget);
    expect(find.text('자주 만나는 관계'), findsOneWidget);

    await tester.tap(find.text('캘린더'));
    await tester.pumpAndSettle();
    expect(find.text('온정 캘린더'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('다가오는 일정'), findsOneWidget);
  });
}
