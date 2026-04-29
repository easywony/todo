# Feature Checklist
> 새 기능 완료 전 검증 항목

---

## ■ REQUIRED (필수 — 모두 통과해야 PR 가능)

### TCA 구조
- [ ] Feature 폴더에 `{Name}Feature.swift` + `{Name}View.swift` 2파일 존재
- [ ] View는 `@Bindable var store: StoreOf<...>` 만 주입받음
- [ ] 비즈니스 로직이 View가 아닌 Reducer 안에 있음
- [ ] 사이드이펙트(저장/로드/네트워크)가 Effect 내부에서만 실행됨
- [ ] 신규 Dependency는 `liveValue` + `testValue` 모두 구현됨

### 코드 품질
- [ ] 하드코딩된 색상/폰트/간격 없음
- [ ] Magic number 없음 (상수 또는 enum 사용)
- [ ] 함수/변수명이 `development.md` 네이밍 규칙 준수

### 네비게이션 (해당하는 경우)
- [ ] `@Presents` + `.sheet` / `.navigationDestination` 사용
- [ ] 직접 View를 하드코딩한 NavigationLink 없음

---

## □ OPTIONAL (권장)

- [ ] Preview 코드 포함 (`#Preview`)
- [ ] 빈 상태(empty state) UI 처리

---

## ◇ CONDITIONAL (해당할 때만)

- [ ] 새 모델 추가 시 → `Models/` 에 위치하고 `Equatable`, `Identifiable` 채택
- [ ] SwiftData 사용 시 → `@Model` 매크로 적용
