# Onjung

> 경조사에서 오간 마음을 사람·상황·시간과 함께 기억하는 관계 장부.

Onjung(온정)은 결혼식, 장례식, 돌잔치, 생일, 개업 같은 경조사에서 **누구와 어떤 마음을 주고받았는지** 기록하고 다시 찾기 위한 Flutter 모바일 앱입니다. 단순 금액 장부가 아니라 상대와의 관계, 경조사 종류, 날짜, 메모, 이전 기록과 다가오는 일정을 함께 보며 다음 관계 행동을 자연스럽게 결정하는 것이 제품의 중심입니다.

이 저장소의 초기 구현에는 경조사비 입력, 주소록 관계 기록, 캘린더, 통계, Firebase 인증, SQLite 저장, 내가 주최하는 경조사의 하객/방명록 관리까지 확장하려던 실제 개발 흔적이 남아 있습니다. 현재 `main`은 그 원래 제품 목적을 유지하면서, backend 상태와 무관하게 즉시 체험 가능한 portfolio-ready 모바일 흐름으로 다시 완성한 버전입니다.

## Preview

<p align="center">
  <img src=".github/assets/portfolio/01-home.png" width="210" alt="Onjung home" />
  <img src=".github/assets/portfolio/02-records.png" width="210" alt="Onjung records" />
  <img src=".github/assets/portfolio/03-record-detail.png" width="210" alt="Onjung record detail" />
</p>

<p align="center">
  <img src=".github/assets/portfolio/04-add-record.png" width="210" alt="Add an Onjung record" />
  <img src=".github/assets/portfolio/05-my-onjung.png" width="210" alt="My Onjung insights" />
</p>

All preview images were captured from an **Android 15 / API 35 emulator at 1080×2400**, not Flutter Web.

## What it does

- **Relationship-first ledger** — 보낸 온정과 받은 온정을 사람, 관계, 경조사, 날짜와 함께 기록합니다.
- **Onjung records** — 최근 기록을 탐색하고 보냄/받음 기준으로 빠르게 구분합니다.
- **Record detail** — 금액만 보지 않고 당시 상황, 메모, 관계 히스토리를 함께 확인합니다.
- **Quick record** — 방향, 상대, 관계, 경조사, 금액, 메모를 한 흐름에서 입력하고 즉시 기록 목록에 반영합니다.
- **Calendar context** — 날짜별 기록과 다가오는 경조사를 함께 확인합니다.
- **My Onjung** — 보낸/받은 총액, 관계 인사이트, 자주 만나는 관계를 요약합니다.
- **Deterministic demo mode** — Firebase/API가 비어 있거나 오래된 backend가 응답하지 않아도 핵심 제품 흐름이 항상 살아 있습니다.

## User flow

대표 사용자 여정은 실제 navigation과 state update로 연결되어 있습니다.

`Home → 온정록 → 온정 상세 → 빠른 온정 기록 → 저장 → 갱신된 온정록 → 내 온정 / 캘린더`

Android Emulator QA에서는 5개의 초기 기록에서 새 결혼식 기록을 저장한 뒤 **6개의 기록**으로 즉시 갱신되고, 이어서 관계 인사이트 화면까지 이동하는 흐름을 검증했습니다.

## Architecture

현재 지원하는 portfolio runtime은 작고 명확하게 구성했습니다.

```text
lib/main.dart
  └─ ProviderScope
      └─ lib/portfolio/onjung_portfolio_app.dart
          ├─ Material 3 UI + navigation
          ├─ Riverpod StateNotifier
          └─ lib/portfolio/data/onjung_demo_repository.dart
              └─ deterministic domain sample data
```

기존 개발 과정의 `lib/core`, `lib/data`, `lib/features`, `lib/shared` 아래에는 Firebase/Auth, SQLite, 주소록, 캘린더, 통계, 하객 관리 등 원래 구현이 보존되어 있습니다. 현재 앱 진입점은 이 오래된 backend 의존성에 묶이지 않으며, portfolio runtime은 별도 deterministic repository를 사용합니다. 따라서 인증 서버나 Firestore 상태 때문에 앱이 흰 화면·무한 로딩·빈 화면으로 끝나지 않습니다.

## Tech Stack

- Flutter 3.27 / Dart 3.6
- Material 3 + Pretendard
- Riverpod (`StateNotifier`)
- `intl`
- Android API 35
- Original implementation history: GoRouter, Firebase Auth / Firestore / Remote Config, SQLite, Table Calendar, Flutter Map

## Run

```bash
flutter pub get
flutter run
```

Portfolio/demo flow에는 별도 API key나 로그인 계정이 필요하지 않습니다.

## Validation

2026-08-20 기준 canonical runtime에서 다음을 확인했습니다.

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

- `flutter analyze`: **No issues found**
- `flutter test`: core journey widget test 통과
- Android debug APK: `build/app/outputs/flutter-apk/app-debug.apk` 생성 성공
- Android Emulator: API 35, 1080×2400
- Runtime QA: Home → list → detail → add/save → updated list → My Onjung navigation 확인
- Runtime log: Flutter exception, RenderFlex overflow, asset load failure 없음

## Product history

Onjung은 처음부터 marketplace나 SNS가 아니라, 한국의 경조사 문화에서 오가는 금액과 마음을 **관계의 맥락으로 기억하기 위한 앱**으로 개발되었습니다. 이번 정리는 그 제품 아이디어를 바꾸는 대신, 기존 구현의 핵심을 유지하면서 오늘 다시 실행해도 제품처럼 보이고 탐색 가능한 모바일 경험으로 다듬는 데 초점을 맞췄습니다.
