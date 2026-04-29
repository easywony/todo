# Todo

개인용 iOS 할 일 관리 앱. Swift + SwiftUI + TCA(The Composable Architecture) 기반.

---

## 화면 구성

| 화면 | 설명 |
|------|------|
| **TodoList** | 할 일 목록. 완료 토글, 스와이프 삭제, 우선순위 필터/정렬 |
| **AddTodo** | 할 일 추가 시트. 제목·우선순위·마감일 입력 |
| **TodoDetail** | 상세 조회 및 수정·삭제 |

## 주요 기능

- 할 일 추가 / 수정 / 삭제
- 완료 토글 (낙관적 업데이트)
- 우선순위 필터 — 전체 / 높음 / 중간 / 낮음
- 정렬 — 추가순 / 마감일순 / 우선순위순
- 마감일 설정 (선택)
- UserDefaults 영속성

---

## 기술 스택

| 항목 | 내용 |
|------|------|
| Language | Swift 5.9+ |
| UI | SwiftUI |
| Architecture | TCA (The Composable Architecture) 1.25.5 |
| Minimum iOS | 17.0 |
| Persistence | UserDefaults + JSONCodable |
| Package Manager | Swift Package Manager |

---

## 프로젝트 구조

```
todo/
├── App/
│   └── todoApp.swift               # 앱 진입점
├── Models/
│   └── Todo.swift                  # 데이터 모델
├── Dependencies/
│   └── TodoRepository.swift        # 저장소 추상화 (TCA Dependency)
├── Features/
│   ├── TodoList/
│   │   ├── TodoListFeature.swift   # Reducer (State, Action, Effect)
│   │   └── TodoListView.swift      # View + TodoRowView
│   ├── AddTodo/
│   │   ├── AddTodoFeature.swift
│   │   └── AddTodoView.swift
│   └── TodoDetail/
│       ├── TodoDetailFeature.swift
│       └── TodoDetailView.swift
└── Resources/
    └── DesignTokens.swift          # 우선순위 색상·레이블 토큰
```

---

## 아키텍처 원칙

- **View → Store만**: 비즈니스 로직은 Reducer 안에서만 처리
- **Dependency 주입**: 외부 의존성은 `@Dependency`로 주입
- **낙관적 업데이트**: State 먼저 변경 후 Effect로 저장
- **디자인 토큰**: 색상은 `Assets.xcassets` 컬러셋 사용 (하드코딩 금지)

---

## 실행 방법

1. Xcode 16 이상 필요
2. 프로젝트 클론 후 `todo.xcodeproj` 실행
3. SPM 패키지가 자동으로 설치됨 (`swift-composable-architecture`)
4. 시뮬레이터 또는 실기기에서 빌드·실행
