# Onjung v1

경조사와 인간관계에서 오가는 기록을 **개인 통계·관계별 평균·캘린더·주소록** 관점으로 정리하는 Flutter 앱 아이디어를 구현한 프로젝트입니다.

A Flutter product experiment for organizing social-event records through personal statistics, relationship averages, calendar views, and an address-book-oriented workflow.

## UI Preview / 구현 화면

![Onjung portfolio preview](https://raw.githubusercontent.com/oosuhada/portfoli-oh/main/project/projects/project4-cover.png)

2025 개인 포트폴리오에 보존된 실제 Onjung project cover입니다. Flutter를 직접 실행하지 않아도 당시 제품의 visual direction을 확인할 수 있습니다.

This is the real Onjung project cover preserved in the 2025 portfolio archive, included so the interface can be understood without running Flutter.

## Features / 주요 구현

- Onboarding / login / signup 화면
- 개인 Onjung 통계 화면
- 관계별 평균 및 최근 사용 통계
- chart/summary card 기반 dashboard UI
- Calendar tab
- Address tab
- Onjung record tab
- hamburger navigation / app routing / theme 구성

## Structure / 구조

```text
lib/
├── core/                    # router, theme
├── data/                    # dummy data and statistics models
└── features/
    ├── onboarding_auth/
    ├── home_tab/
    ├── calendar_tab/
    ├── address_tab/
    ├── onjung_tab/
    └── main_screen.dart
```

이 저장소는 Onjung 제품 아이디어의 첫 mobile implementation이며, 이후 `flutter_onjung_web_test`에서 주소록·캘린더·빠른 입력·방명록 등 더 넓은 web/mobile surface를 실험했습니다.

This repository is the first mobile implementation of the Onjung concept; the later web-test repository explores a broader ceremony-book and guest-book surface.

