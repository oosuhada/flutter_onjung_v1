# Onjung v2 · 온정

> **A relationship-first ledger for remembering the care exchanged around life events.**
> **경조사에서 주고받은 마음을 사람·관계·상황과 함께 기억하는 관계 중심 장부입니다.**

This is a **2026 UX renewal** of the Flutter project I first built while learning mobile product development in 2024. The goal is not to cover every screen with blur, but to revisit the same product with a clearer interaction hierarchy, adaptive controls, motion/accessibility fallbacks, platform conventions, and rendering-cost awareness.

2024년에 Flutter를 처음 배우며 기능 구현 중심으로 만들었던 프로젝트를, 2026년에 **interaction hierarchy, adaptive UI, motion, accessibility, platform convention, rendering cost**를 기준으로 다시 설계한 UX renewal입니다. 모든 화면을 반투명하게 만드는 것이 아니라, 기록 리스트·사진처럼 읽기 중요한 콘텐츠는 선명하게 유지하고 navigation/action/search와 summary·metadata·insight surface를 강도별 glass hierarchy로 분리했습니다.

**Branches / 버전** · [`v1` · original portfolio version](https://github.com/oosuhada/flutter_onjung_v1/tree/v1) · [`main` · v2 renewal](https://github.com/oosuhada/flutter_onjung_v1)

## v1 → v2 · 성장 과정

| | v1 · 2024 | v2 · 2026 |
| --- | --- | --- |
| Focus / 초점 | Feature implementation / 기능 구현 학습 | Product UX renewal / 제품 UX 재설계 |
| Hierarchy / 위계 | Screen-by-screen Material UI | Content vs. control separation |
| Navigation | Standard Material navigation | Floating adaptive glass navigation |
| Search & filters | Static/basic controls | Searchable records + compact segmented control |
| Motion | Default widget transitions | Reduced-motion-aware implicit animation |
| Accessibility | Basic Material semantics | Selected-state semantics, minimum tap targets, high-contrast fallback |
| Rendering | Visual styling first | Glass-themed surface hierarchy for controls, summaries, metadata, and insights while record lists/photos stay sharp |

> **Why did I change it? / 왜 바꿨나요?**  
> In v1 I was mainly focused on making screens and features work. In v2 I kept the same product idea and reworked the experience around interaction hierarchy, motion, accessibility, platform conventions, and rendering cost.  
> v1에서는 화면과 기능을 동작시키는 데 집중했다면, v2에서는 같은 제품을 유지하면서 interaction hierarchy, motion, accessibility, platform convention, rendering cost까지 함께 고려했습니다.

## About Onjung · 제품 소개

Onjung is a Flutter mobile app for recording and revisiting the money and care exchanged around weddings, funerals, first-birthday celebrations, birthdays, openings, and other important life events. Instead of treating each entry as a simple amount, it keeps the **relationship context**—who the person is, what happened, when it happened, and what you want to remember.

온정은 결혼식, 장례식, 돌잔치, 생일, 개업 등 경조사에서 오간 금액과 마음을 기록하고 다시 찾기 위한 Flutter 모바일 앱입니다. 단순한 금액 장부가 아니라 **누구와 어떤 관계인지, 어떤 경조사였는지, 언제 있었는지, 무엇을 기억할지**를 함께 남기는 것이 핵심입니다.

## Demo Runtime · 데모 실행 환경

The current `main` keeps the original product direction while providing a deterministic demo runtime, so the core mobile flow remains usable even when the legacy Firebase/backend environment is unavailable.

현재 `main`은 원래 제품 방향을 유지하면서 deterministic demo runtime을 제공해, 기존 Firebase/backend가 동작하지 않는 환경에서도 핵심 모바일 흐름을 바로 체험할 수 있습니다.

## Preview · 미리보기

<p align="center">
  <img src=".github/assets/portfolio/01-home.png" width="210" alt="Onjung home dashboard" />
  <img src=".github/assets/portfolio/02-records.png" width="210" alt="Onjung records" />
  <img src=".github/assets/portfolio/03-record-detail.png" width="210" alt="Onjung record detail" />
</p>

<p align="center">
  <strong>01 · Home / 홈</strong>
  &nbsp;&nbsp;|&nbsp;&nbsp;
  <strong>02 · Records / 온정록</strong>
  &nbsp;&nbsp;|&nbsp;&nbsp;
  <strong>03 · Record Detail / 온정 상세</strong>
</p>

<p align="center">
  <img src=".github/assets/portfolio/04-add-record.png" width="240" alt="Add an Onjung record" />
  <img src=".github/assets/portfolio/05-my-onjung.png" width="240" alt="My Onjung insights" />
</p>

<p align="center">
  <strong>04 · Quick Record / 빠른 온정 기록</strong>
  &nbsp;&nbsp;|&nbsp;&nbsp;
  <strong>05 · My Onjung / 내 온정</strong>
</p>

All preview images were captured directly from an **Android 15 / API 35 emulator at 1080×2400**. Flutter Web screenshots are not used.

모든 Preview 이미지는 **Android 15 / API 35 Emulator, 1080×2400**에서 직접 캡처했습니다. Flutter Web screenshot은 사용하지 않았습니다.

## What it does · 주요 기능

- **Home summary / 홈 요약** — See this month's sent/received care and recent records at a glance. / 이번 달 보낸·받은 온정과 최근 기록을 한눈에 확인합니다.
- **Onjung records / 온정록** — Search by person, relationship, event, or memo, then narrow the list with sent/received filtering. / 이름, 관계, 경조사, 메모를 검색하고 보냄/받음 필터로 기록을 좁힙니다.
- **Record detail / 온정 상세** — Review the amount together with notes and relationship context. / 금액뿐 아니라 당시 메모와 관계 맥락을 함께 확인합니다.
- **Quick record / 빠른 기록** — Enter direction, person, relationship, event, amount, and memo in one flow, then update the list immediately. / 방향, 상대, 관계, 경조사, 금액, 메모를 한 흐름에서 입력하고 저장 즉시 목록에 반영합니다.
- **Calendar & My Onjung / 캘린더 & 내 온정** — Review date-based records, upcoming events, totals, and relationship insights. / 날짜별 기록, 다가오는 경조사, 보낸·받은 총액과 관계 인사이트를 확인합니다.
- **Deterministic demo fallback / 데모 fallback** — The core flow remains usable without Firebase or the legacy backend. / Firebase나 기존 backend가 없어도 핵심 모바일 흐름이 동작합니다.

## User flow · 사용자 흐름

`Home → Records → Record detail → Quick record → Save → Updated records → My Onjung / Calendar`

`홈 → 온정록 → 온정 상세 → 빠른 온정 기록 → 저장 → 갱신된 온정록 → 내 온정 / 캘린더`

During Android Emulator QA, the app started with five records, saved a new wedding record, and immediately updated the list to **six records**.

Android Emulator QA에서는 초기 5개 기록에서 새 결혼식 기록을 저장한 뒤 **6개 기록으로 즉시 갱신**되는 state update까지 확인했습니다.

## Architecture · 아키텍처

```text
lib/main.dart
  └─ ProviderScope
      └─ lib/portfolio/onjung_portfolio_app.dart
          ├─ solid content surfaces + product flow
          ├─ Riverpod StateNotifier
          ├─ lib/v2/v2_glass.dart
          │   ├─ V2GlassTheme
          │   ├─ AppGlassSurface
          │   ├─ AppGlassNavigationBar / ActionButton
          │   ├─ AppGlassTextField / SegmentedControl
          │   └─ AppGlassToolbar
          └─ lib/portfolio/data/onjung_demo_repository.dart
              └─ deterministic domain sample data
```

The portfolio runtime is intentionally small: Flutter/Material UI, Riverpod state, and a deterministic repository provide the current runnable experience. The original `lib/core`, `lib/data`, `lib/features`, and `lib/shared` code remains in the repository and contains the earlier Firebase/Auth, SQLite, address-book, calendar, statistics, and guest-management implementation.

현재 portfolio runtime은 Flutter/Material UI, Riverpod 상태 관리, deterministic repository를 중심으로 작게 구성했습니다. 기존 `lib/core`, `lib/data`, `lib/features`, `lib/shared`에는 Firebase/Auth, SQLite, 주소록, 캘린더, 통계, 하객 관리 등 원래 앱의 구현이 보존되어 있습니다.

## v2 visual system · v2 디자인 시스템

The v2 glass layer separates **controls from contextual summary surfaces**. Record list rows, photos, and dense calendar data stay sharp, while record-count metadata, detail summary/amount/memo panels, quick-record guidance, My Onjung totals, upcoming-event context, and relationship insights use lower-intensity translucent surfaces.

v2의 glass layer는 **control과 보조 summary surface를 서로 다른 강도로 계층화**합니다. 기록 목록, 사진, 밀도 높은 캘린더 데이터는 선명하게 유지하고, 기록 개수 metadata, 상세 요약·금액·메모 panel, 빠른 기록 안내, 내 온정 합계, 다가오는 일정, 관계 insight에는 낮은 강도의 adaptive translucent layer를 적용했습니다.

- **Adaptive transparency / 적응형 투명도** — `MediaQuery.highContrast`에서는 blur를 제거하고 surface opacity를 높입니다.
- **Reduced motion / 모션 감소** — `MediaQuery.disableAnimations`에서는 navigation/filter transition duration을 0으로 줄입니다.
- **Accessible controls / 접근 가능한 컨트롤** — selected semantics와 42–54px 이상의 control height를 사용합니다.
- **Rendering-cost aware blur / 렌더링 비용 고려** — 반복되는 record list item이나 calendar cell마다 `BackdropFilter`를 만들지 않고 navigation/search/toolbar와 의미 있는 summary surface에만 선택적으로 blur를 적용합니다.
- **Future renderer boundary / 확장 가능한 경계** — UI는 `AppGlass*` contract를 통해 사용하므로 향후 native material 또는 shader 구현으로 교체해도 product screen 코드는 크게 바꾸지 않도록 구성했습니다.

## Tech Stack · 기술 스택

- Flutter 3.27 / Dart 3.6
- Material 3 + Pretendard
- Riverpod (`StateNotifier`)
- `intl`
- Android API 35
- Original implementation / 기존 구현: GoRouter, Firebase Auth / Firestore / Remote Config, SQLite, Table Calendar, Flutter Map

## Run · 실행

```bash
flutter pub get
flutter run
```

The portfolio/demo flow does not require an API key or login account.
Portfolio/demo 흐름은 별도 API key나 로그인 계정 없이 실행할 수 있습니다.

## Product history · 제품 배경

Onjung began as a product for remembering the money and care exchanged in Korean life-event culture **through the context of relationships**, not as a marketplace or social network. This refresh keeps that original idea and turns it into a small mobile product that can still be run and explored today.

온정은 marketplace나 SNS가 아니라, 한국의 경조사 문화에서 오가는 금액과 마음을 **관계의 맥락으로 기억하기 위한 앱**으로 시작했습니다. 이번 정리는 그 목적을 바꾸지 않고 기존 아이디어를 지금도 실행하고 탐색할 수 있는 작은 모바일 제품으로 마무리한 작업입니다.
