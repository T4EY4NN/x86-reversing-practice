# CTF Pwn / Reversing Training State

## 1. Goal

1차 목표는 CTF/대회에서 **pwn 또는 reversing 문제 최소 1문제를 독립적으로 해결**하는 것이다.

빠르게 성장하되 exploit recipe나 tool 사용법만 암기하지 않는다.

최종적으로 처음 보는 바이너리에서:

- memory state 추론
- assembly 분석
- vulnerability 원인 파악
- GDB를 통한 가설 검증
- exploitation 또는 reversing solution으로 연결

을 독립적으로 수행하는 것을 목표로 한다.

---

## 2. Training Philosophy

기본 학습 루프:

Prediction
→ Memory Diagram
→ Assembly Analysis
→ GDB Verification
→ Self Explanation
→ Transfer

정답을 먼저 보지 않는다.

학습 상태는 다음 세 단계로 구분한다.

### Learned
개념을 학습했다.

### Verified
GDB 또는 실습으로 직접 확인했다.

### Independent
처음 보는 문제에서 AI 도움 없이 적용할 수 있다.

**정답이나 핵심 풀이를 본 문제는 Independent의 증거로 사용하지 않는다.**

---

## 3. Tutor Roles

### ChatGPT — Foundation / Reasoning

담당:

- C memory model
- address / value
- datatype / endianness
- pointer / array / string
- stack frame
- x86-64 assembly
- calling convention
- ELF / symbols / sections
- GDB
- memory corruption 원리
- mitigation 원리
- reversing / binary reasoning

목표:

**처음 보는 바이너리의 동작을 스스로 추론할 수 있는 mental model 구축**

### Claude — Exploitation / CTF Application

담당:

- toy vulnerable binaries
- stack overflow exploitation
- ret2win
- pwntools
- ROP
- information leak
- mitigation-aware pwn
- 이후 heap exploitation
- CTF-style pwn challenges

목표:

**foundation을 실제 CTF exploitation 능력으로 연결**

---

## 4. Capability Gate

진도는 주차가 아니라 실제 능력으로 결정한다.

TRAINING_STATE.md의 자기보고만 신뢰하지 않는다.

새로운 단계에 진입하기 전 짧은 diagnostic / mini task를 수행한다.

예:

첫 stack exploitation 진입 전에는 처음 보는 간단한 함수에서 다음을 스스로 설명할 수 있어야 한다.

- local variables
- buffer
- RSP / RBP
- saved frame pointer
- saved return address
- call / ret에 따른 stack 변화

그리고 이를 assembly + GDB로 검증할 수 있어야 한다.

---

## 5. Hint Ladder

### Level 0 — Independent
직접 분석 / 예측 / GDB / 코딩

### Level 1 — Direction
조사할 방향만 제시

### Level 2 — Concept Hint
관련 개념을 지적

### Level 3 — Concrete Hint
확인할 register / address / instruction 등에 가까운 힌트

### Level 4 — Partial Solution
풀이 일부 제공

### Level 5 — Full Explanation
전체 원리와 풀이 설명

생산적으로 debugging 중이라면 단순 시간 경과만으로 정답을 제공하지 않는다.

가능한 최소 수준의 hint만 사용한다.

---

## 6. Failure-First Debugging

예상과 실행 결과가 다르면 즉시 정답을 확인하지 않는다.

Prediction
→ Execution
→ Failure
→ Find First Divergence
→ Hypothesis
→ GDB Verification
→ Correction
→ Retry

항상 먼저 질문한다:

> "내 예상과 실제 실행이 처음 달라지는 지점은 어디인가?"

성공 이유뿐 아니라 **실패 원인을 독립적으로 진단하는 능력**을 훈련한다.

---

## 7. Transfer Test

각 주요 기술은 가능하면 다음 순서로 평가한다.

### A. Guided
튜터와 함께 분석

### B. Assisted
최소한의 hint로 해결

### C. Unseen
처음 보는 문제를 가능한 AI 도움 없이 해결

Unseen 단계에서 성공해야 `Independent`로 판단한다.

---

## 8. Problem Progression

문제는 가능하면 다음 순서로 진행한다.

### 1. Custom Toy Binary
개념 하나를 격리해서 학습한다.

### 2. Curated Public Challenge
다운로드 가능한 실제 CTF / wargame 문제를 통해 적용한다.

### 3. Unseen Challenge
풀이를 보지 않은 새로운 문제로 transfer를 평가한다.

---

## 9. Environment

### User Local Environment

현재 기본 학습 환경:

- x86-64 Linux / WSL 계열
- GCC
- GDB
- Intel syntax 선호
- 초기 foundation 단계에서는 vanilla GDB 사용
- pwndbg는 필요 시 이후 단계에서 활성화
- 기본 compile 예: `gcc -g -O0`

학습 결과물은 GitHub repository에 지속적으로 저장한다.

Repository:

`x86-reversing-practice`

주요 구조:

- `fundamentals/`
- `exercises/`
- `templates/`
- `TRAINING_STATE.md`

빌드 결과물은 `build/`에 두고 Git에서 제외한다.

### Claude Execution Environment

Claude 측 실습 환경에는 다음 제약이 있을 수 있다.

- 원격 CTF 서버에 직접 `nc`로 접속할 수 없음
- public challenge는 가능한 다운로드 가능한 binary를 사용
- remote interaction이 필요한 경우 사용자가 직접 실행하고 결과를 전달
- 세션 종료 후 container 상태가 유지되지 않을 수 있음
- binary / exploit script / 설정 등 지속할 자료는 사용자 GitHub에 보관
- `pwntools`, `checksec`, `pwndbg`, `gef` 등의 사용 가능 여부는 첫 lab에서 environment recon으로 확인

환경 상태를 가정하지 말고 필요한 tool은 실습 시작 시 확인한다.

---

## 10. Mitigation Synchronization

Mitigation의 원리 학습과 exploitation 적용 사이의 간격을 최소화한다.

예:

Canary Principle
→ GDB Observation
→ Vulnerable Program
→ Exploitation Lab
→ Explanation / Transfer

NX / PIE / ASLR / RELRO도 같은 원칙을 적용한다.

---

## 11. Tutor Feedback Loop

Claude 실습에서 foundation 부족이 발견되면 기록한다.

예:

Weakness detected:
- saved RIP / RSP relationship
- calling convention
- endian reconstruction
- pointer arithmetic

Foundation 문제라면 ChatGPT에서 보강한다.

Exploitation technique 문제라면 Claude에서 계속 훈련한다.

ChatGPT
→ Foundation / Reasoning
→ Claude
→ Exploitation / Application
→ Failure Diagnosis
→ Appropriate Tutor
→ Retry

---

## 12. Current Curriculum

### Phase 1 — Memory Foundation ← CURRENT
C memory / pointers / arrays / strings / endian

### Phase 2 — Stack + x86
stack frame / registers / call / ret / ABI

### Phase 3 — Binary Reasoning
ELF / symbols / sections / disassembly / GDB

### Phase 4 — Bug Foundation
OOB / overflow / format string / UAF 등 memory corruption 원리

### Phase 5 — Mitigations
NX / ASLR / PIE / Canary / RELRO

### Phase 6 — CTF Bridge
분석 → 가설 → 검증 → exploitation / reversing solution

Target:
**Easy unseen pwn/reversing challenge independent solve**

---

## 13. Current Progress

### Lab 1 — Address / Datatype / Endianness
Status: Completed

Covered:
- char / short / int / pointer size
- little endian
- p / *p / &p
- GDB x/NFU
- pointer arithmetic
- array decay
- arr / &arr / &arr[0]

### Lab 2 — Same Address, Different Pointer Type
Status: Completed

Covered:
- unsigned char *
- unsigned short *
- unsigned int *
- dereference width
- pointer arithmetic stride
- pointer size vs pointee size
- GDB p vs x

### Lab 3 — Memory Mutation / C ↔ Assembly
Status: Completed

Example:

unsigned int value = 0x11223344;
unsigned char *cp = (unsigned char *)&value;
*((unsigned short *)cp + 1) = 0xBEEF;

Initial:

[44][33][22][11]

Final:

[44][33][EF][BE]

value = 0xBEEF3344

Observed at -O0:

- local variables remained visible
- cp stored an address
- pointer arithmetic became byte-level address arithmetic
- WORD / DWORD / QWORD memory accesses observed

Observed at -O2:

mov eax, 0xbeef3344
ret

Compiler eliminated unnecessary intermediate operations.

---

## 14. Current Knowledge State

### Learned + Verified

- little endian
- datatype sizes
- address vs value
- p / *p / &p
- pointer arithmetic
- pointer size vs pointee size
- array decay
- arr / &arr / &arr[0]
- BYTE / WORD / DWORD / QWORD PTR
- address vs [address]
- basic C → x86 correspondence
- basic GDB memory examination

### Independent

Not yet formally evaluated.

Independent status requires unseen transfer testing.

---

## 15. Recurring Error Patterns

Track these during future retrieval tests:

1. address vs value
2. address expression vs memory contents `[address]`
3. pointer object size vs pointee size
4. arr vs &arr vs &arr[0]
5. decimal vs hexadecimal address arithmetic
6. dereference width after pointer cast

Some have improved during Labs 2–3 but remain retrieval targets.

---

## 16. Next Session

1. Short retrieval test
2. Verify retained Week 1 knowledge
3. Continue Memory Foundation
4. Increase C ↔ x86 integration
5. Prepare for Stack + x86 capability gate

Claude exploitation track should **not begin solely because a curriculum date is reached.**

First stack-oriented exploitation lab begins after the relevant capability gate is passed.

---

## 17. End Goal

AI assistance should progressively decrease.

The training is successful when I can take an unseen beginner-level pwn/reversing challenge and independently:

Recon
→ Analyze
→ Form Hypothesis
→ Debug
→ Explain
→ Solve