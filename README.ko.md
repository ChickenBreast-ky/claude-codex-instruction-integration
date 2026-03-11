# Claude Codex Instruction Integration

[English README](./README.md)

Claude와 Codex가 하나의 편집 기준 지침 파일을 공유하도록 정리해주는 공개 스킬입니다. 새로 요청된 스킬을 Claude 원본 + Codex 링크 구조로 맞추는 규칙도 함께 제공합니다.

## 이 스킬이 하는 일

이 스킬은 Claude/Codex 환경을 한 원본 기준으로 정리하는 초기세팅 스킬입니다.

핵심 기능은 3가지입니다:

1. 전역 지침 정리
   - `~/.claude/CLAUDE.md` 를 기준 원본으로 둡니다.
   - Codex 쪽은 그 파일을 호환용 심볼릭 링크로 읽게 맞춥니다.
   - 기존 `agent.md` 계열 파일에 다른 내용이 있으면, 바로 덮지 않고 먼저 차이를 보여주고 병합 여부를 묻습니다.
2. 신규 스킬 연결 규칙 추가
   - 사용자가 새로 설치하거나 새로 생성하라고 직접 요청한 스킬만 Claude 원본 + Codex 링크 구조로 운영합니다.
   - 기존 내장 스킬이나 예전부터 있던 스킬을 자동으로 전부 동기화하지 않습니다.
3. 삭제 안전 규칙 추가
   - 파일이나 디렉토리를 바로 삭제하지 않고 `~/.trash-staging/` 으로 먼저 옮긴 뒤, 승인 후 실제 삭제하도록 유도합니다.

## 실행 모드

실행 모드는 2가지입니다:

- `New machine setup`
  - 거의 빈 환경이라고 보고 표준 구조를 빠르게 적용합니다.
  - 예상 밖의 기존 파일이 있을 때만 질문합니다.
- `Existing machine cleanup and apply`
  - 현재 파일과 링크 상태를 먼저 조사합니다.
  - 예전 지침이 있으면 차이를 정리해서 보여주고, 병합 여부를 물은 뒤 적용합니다.

## 설치 방법

스킬 폴더를 Claude skills 경로에 복사한 뒤, Codex skills 경로에서 그 폴더를 바라보는 링크를 만듭니다.

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
cp -R ./skill/claude-codex-instruction-integration ~/.claude/skills/claude-codex-instruction-integration
ln -sfn ~/.claude/skills/claude-codex-instruction-integration ~/.codex/skills/claude-codex-instruction-integration
```

## 사용 예시

사람이 그대로 말하면 되는 문장:

- `Use $claude-codex-instruction-integration in new-machine mode and apply the setup.`
- `Use $claude-codex-instruction-integration in existing-machine mode, inspect the current state, then clean up and apply the setup.`

## 저장소 구조

- `skill/claude-codex-instruction-integration/`
  - 실제로 설치하는 스킬 폴더입니다.
- `README.md`
  - 영어 설명 문서입니다.
- `README.ko.md`
  - 한국어 설명 문서입니다.

## 참고

- 이 스킬은 `~/.claude`, `~/.codex`, `~/.trash-staging` 같은 일반적인 홈 디렉토리 경로를 예시로 사용합니다.
- 자신의 환경에 맞게 정책 스니펫을 조금 조정해서 써도 됩니다.
