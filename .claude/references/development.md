# Development Reference
> 코딩 컨벤션 & 네이밍 규칙

---

## 네이밍 규칙

| 대상 | 규칙 | 예시 |
|------|------|------|
| Feature | `{Name}Feature` | `TodoListFeature` |
| View | `{Name}View` | `TodoListView` |
| State | Feature 내부 struct | `TodoListFeature.State` |
| Action | Feature 내부 enum | `TodoListFeature.Action` |
| Model | 명사형 | `Todo`, `Category` |
| Dependency | `{Name}Repository` | `TodoRepository` |

## 파일 네이밍
- Feature 파일: `{FeatureName}Feature.swift`
- View 파일: `{FeatureName}View.swift`
- 모델: `{ModelName}.swift`
- 의존성: `{Name}Repository.swift`

---

## 커밋 컨벤션

```
feat: 새로운 기능 추가
fix: 버그 수정
refactor: 코드 리팩토링 (기능 변경 없음)
chore: 빌드 설정, 패키지 업데이트
docs: 문서 수정
style: 코드 포맷팅 (기능 변경 없음)
test: 테스트 코드
```

예시:
```
feat: 할 일 완료 토글 기능 추가
fix: 빈 제목으로 저장되는 버그 수정
refactor: TodoRepository fetchAll 비동기 처리 개선
```

---

## 브랜치 전략

```
main              — 배포 가능한 상태만 유지
develop           — 통합 브랜치
feature/{name}    — 기능 개발 (예: feature/add-todo)
fix/{name}        — 버그 수정 (예: fix/empty-title-crash)
refactor/{name}   — 리팩토링
```

---

## Swift 코드 스타일

- `guard let` / `guard else` 적극 활용, 깊은 중첩 금지
- `async/await` 사용, completion handler 금지
- `@Sendable` 클로저는 Dependency에서 항상 명시
- `IdentifiedArray` 사용 (TCA 표준, 배열 + id 검색 O(1))
- Magic number 금지 — 상수나 enum으로 추출

---

## 디자인 토큰 규칙

```swift
// ❌ 하드코딩 금지
.foregroundStyle(Color(hex: "#FF3B30"))
.font(.system(size: 16, weight: .semibold))
.padding(12)

// ✅ 토큰 사용
.foregroundStyle(Color.appRed)
.font(.appBody)
.padding(.md)
```

`Resources/DesignTokens.swift` 에서 중앙 관리한다.
