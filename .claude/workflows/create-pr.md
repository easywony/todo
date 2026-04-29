# Workflow: PR 생성
> 트리거: PR, 피알, 풀리퀘, 작업완료, 올려줘, merge

---

## 실행 순서

### Step 1. 변경사항 확인
```bash
git status
git diff --stat
```

### Step 2. pr-checklist.md 검증
`.claude/checklists/pr-checklist.md` 를 읽고 모든 REQUIRED 항목 통과 확인

### Step 3. 커밋 (미커밋 변경사항이 있을 때만)
```bash
git add .
git commit -m "{type}: {작업 내용 요약}"
```
커밋 타입은 `development.md` 커밋 컨벤션 참고

### Step 4. 브랜치 Push
```bash
git push origin {현재 브랜치명}
```

### Step 5. PR 본문 자동 생성
아래 템플릿으로 PR 본문을 작성한다.

```markdown
## 변경 내용
{변경한 기능/수정 내용 요약}

## 주요 변경 파일
- `{파일명}` — {변경 이유}

## 체크리스트
- [ ] TCA 규칙 준수 (View → Store만, 로직 → Reducer만)
- [ ] 하드코딩 없음 (색상/폰트/간격 토큰 사용)
- [ ] 새 Dependency는 testValue 구현 포함
- [ ] 커밋 메시지 컨벤션 준수
```

### Step 6. GitHub PR 생성
```bash
gh pr create \
  --title "{type}: {작업 내용 요약}" \
  --body "{Step 5에서 생성한 본문}" \
  --base develop
```

---

## ■ REQUIRED
- PR 본문 템플릿 필수 작성
- base 브랜치는 반드시 `develop`

## □ OPTIONAL
- 스크린샷 첨부 (UI 변경이 있을 경우 권장)
