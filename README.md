# x86 Reversing Practice

간단한 C 코드를 직접 컴파일하고 x86-64 디스어셈블 결과를 분석하는 연습 저장소입니다.

## 목표

- x86-64 어셈블리 명령어 익히기
- C 코드와 컴파일된 어셈블리의 대응 관계 이해하기
- 함수 호출 규약과 스택 프레임 이해하기
- GDB를 이용해 레지스터와 메모리 변화 검증하기
- 최적화 수준에 따른 코드 변화 비교하기

## 연습 과정

1. 간단한 C 함수 구현
2. 어셈블리 형태 예측
3. `-O0`으로 컴파일
4. 원본 C 코드를 보지 않고 디스어셈블 분석
5. C 코드 형태로 다시 복원
6. GDB를 이용한 추론 검증
7. `-O2` 결과와 비교
8. 분석 과정과 실수를 Markdown으로 기록

## 환경

- WSL2
- Ubuntu 22.04
- GCC
- GDB
- GNU objdump
- Visual Studio Code

## 진행 상황

| 번호 | 함수 | C 구현 | O0 분석 | GDB 검증 | O2 비교 |
|---|---|---:|---:|---:|---:|
| 01 | `my_memset` | ✅ | ⬜ | ⬜ | ⬜ |
| 02 | `my_strlen` | ⬜ | ⬜ | ⬜ | ⬜ |
| 03 | `my_memcpy` | ⬜ | ⬜ | ⬜ | ⬜ |
| 04 | `my_strcmp` | ⬜ | ⬜ | ⬜ | ⬜ |

## 디렉터리 구조

```text
exercises/
└── 01-my-memset/
    ├── source.c
    ├── disassembly-O0.asm
    ├── disassembly-O2.asm
    └── analysis.md