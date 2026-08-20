# Onjung

> 경조사에서 주고받은 마음을 사람·관계·상황과 함께 기억하는 Flutter 모바일 앱.

Onjung(온정)은 결혼식, 장례식, 돌잔치, 생일, 개업 같은 경조사 기록을 단순 금액 장부가 아니라 **관계의 맥락**으로 남기고 다시 찾을 수 있게 만든 앱입니다. 현재 `main`은 원래 제품 방향을 유지하면서, backend 상태와 무관하게 핵심 흐름을 바로 체험할 수 있는 deterministic demo runtime을 제공합니다.

## Preview

<p align="center">
  <img src=".github/assets/portfolio/01-home.png" width="210" alt="Onjung home dashboard" />
  <img src=".github/assets/portfolio/02-records.png" width="210" alt="Onjung records" />
  <img src=".github/assets/portfolio/03-record-detail.png" width="210" alt="Onjung record detail" />
</p>

<p align="center"><sub>Home · 온정록 · 온정 상세</sub></p>

<p align="center">
  <img src=".github/assets/portfolio/04-add-record.png" width="240" alt="Add an Onjung record" />
  <img src=".github/assets/portfolio/05-my-onjung.png" width="240" alt="My Onjung insights" />
</p>

<p align="center"><sub>빠른 온정 기록 · 내 온정</sub></p>

모든 Preview는 **Android 15 / API 35 Emulator, 1080×2400**에서 직접 캡처했습니다. Flutter Web screenshot은 사용하지 않았습니다.

## What it does

- **Home summary** — 이번 달 보낸/받은 온정과 최근 기록을 한눈에 확인합니다.
- **온정록** — 사람, 관계, 경조사, 날짜를 기준으로 기록을 탐색하고 보냄/받음을 구분합니다.
- **Record detail** — 금액뿐 아니라 당시 메모와 관계 맥락을 함께 확인합니다.
- **Quick record** — 방향, 상대, 관계, 경조사, 금액, 메모를 한 흐름에서 입력하고 저장 즉시 목록에 반영합니다.
- **Calendar & My Onjung** — 날짜별 기록, 다가오는 경조사, 보낸/받은 총액과 관계 인사이트를 확인합니다.
- **Demo fallback** — Firebase나 기존 backend가 없어도 핵심 모바일 흐름이 항상 동작합니다.

## User flow

`Home → 온정록 → 온정 상세 → 빠른 온정 기록 → 저장 → 갱신된 온정록 → 내 온정 / 캘린더`

Android Emulator QA에서는 초기 5개 기록에 새 결혼식 기록을 저장한 뒤 **6개 기록으로 즉시 갱신**되는 state update까지 확인했습니다.

## Architecture

```text
lib/main.dart
  └─ ProviderScope
      └─ lib/portfolio/onjung_portfolio_app.dart
          ├─ Material 3 UI + navigation
          ├─ Riverpod StateNotifier
          └─ lib/portfolio/data/onjung_demo_repository.dart
              └─ deterministic domain sample data
```

기존 `lib/core`, `lib/data`, `lib/features`, `lib/shared`에는 Firebase/Auth, SQLite, 주소록, 캘린더, 통계, 하객 관리 등 원래 앱의 구현이 보존되어 있습니다. Portfolio runtime은 이 legacy backend 상태에 의존하지 않도록 별도 demo repository를 사용합니다.

## Tech Stack

- Flutter 3.27 / Dart 3.6
- Material 3 + Pretendard
- Riverpod (`StateNotifier`)
- `intl`
- Android API 35
- Original implementation: GoRouter, Firebase Auth / Firestore / Remote Config, SQLite, Table Calendar, Flutter Map

## Run

```bash
flutter pub get
flutter run
```

Portfolio/demo flow에는 별도 API key나 로그인 계정이 필요하지 않습니다.

## Validation

2026-08-21 기준 실제로 수행한 검증입니다.

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

- `flutter analyze` — **No issues found**
- `flutter test` — core journey widget test 통과
- Android debug build — APK 생성 성공
- Android Emulator — API 35 / 1080×2400에서 전체 사용자 흐름 확인
- Runtime QA — Flutter exception, RenderFlex overflow, asset load failure 없음

## Product history

Onjung은 marketplace나 SNS가 아니라, 한국의 경조사 문화에서 오가는 금액과 마음을 **관계의 맥락으로 기억하기 위한 앱**으로 시작했습니다. 이번 정리는 그 목적을 바꾸지 않고 기존 아이디어를 현재도 실행 가능한 작은 모바일 제품으로 마무리한 작업입니다.
