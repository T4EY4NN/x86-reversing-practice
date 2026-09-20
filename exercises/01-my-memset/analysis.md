# 01. `my_memset` 분석

## 1. 학습 목표

- 간단한 C 함수를 x86-64 어셈블리와 대응시킨다.
- 함수 인자가 전달되는 레지스터를 확인한다.
- 지역변수의 스택 위치와 크기를 복원한다.
- 반복문과 unsigned 조건 분기를 이해한다.
- 포인터 자체의 크기와 역참조 대상의 크기를 구분한다.

---

## 진행 현황
보완할 것: GDB로 실제 레지스터·메모리 변화 검증
다음 학습: my_memset에 breakpoint를 걸고 반복문 1회 추적

## 2. 작성한 C 코드

```c
void *my_memset(void *dst, int value, unsigned long count)
{
    unsigned char *p = dst;

    for (unsigned long i = 0; i < count; i++) {
        *(p + i) = (unsigned char)value;
    }

    return dst;
}
```

### 구현 과정에서 수정한 부분

- 반복 변수 `i`를 `int`에서 `unsigned long`으로 변경했다.
  - `count`와 같은 자료형을 사용해 signed/unsigned 비교를 피하기 위해서다.
- 저장할 `value`를 `unsigned char`로 명시적으로 변환했다.
  - `memset`은 `value`의 하위 1바이트만 저장하기 때문이다.
- 테스트 코드에서 `'a'` 대신 `'A'`를 사용했다.
  - `'a'`의 ASCII 값은 `0x61`, `'A'`의 ASCII 값은 `0x41`이다.

---

## 3. 컴파일

```bash
gcc -Wall -Wextra -g -O0 -fno-pie -no-pie \
    -o my_memset_O0 source.c
```

### 컴파일 옵션

| 옵션 | 의미 |
|---|---|
| `-Wall` | 주요 컴파일 경고 활성화 |
| `-Wextra` | 추가 경고 활성화 |
| `-g` | GDB가 사용할 디버깅 정보 포함 |
| `-O0` | 컴파일러 최적화 비활성화 |
| `-fno-pie -no-pie` | PIE를 비활성화해 코드 주소를 단순하게 유지 |

컴파일 경고는 발생하지 않았다.

### 실행 결과

```text
41 41 41 41 41 41 41 41
```

---

## 4. 디스어셈블 명령

```bash
objdump -d -M intel \
    --disassemble=my_memset \
    my_memset_O0
```

- `-d`: 실행 코드를 디스어셈블한다.
- `-M intel`: Intel 문법으로 출력한다.
- `--disassemble=my_memset`: `my_memset` 함수만 출력한다.

---

## 5. 함수 인자 전달

x86-64 System V 호출 규약에 따라 처음 세 인자는 다음 레지스터로 전달됐다.

| C 인자 | 전달 레지스터 | 크기 |
|---|---|---:|
| `dst` | `rdi` | 8바이트 |
| `value` | `esi` | 4바이트 |
| `count` | `rdx` | 8바이트 |

함수는 전달받은 인자를 각각 스택에 저장했다.

```asm
mov QWORD PTR [rbp-0x18], rdi    ; dst
mov DWORD PTR [rbp-0x1c], esi    ; value
mov QWORD PTR [rbp-0x28], rdx    ; count
```

---

## 6. 스택 변수 복원

| 스택 위치 | C 변수 | 크기 |
|---|---|---:|
| `[rbp-0x8]` | `p` | 8바이트 |
| `[rbp-0x10]` | `i` | 8바이트 |
| `[rbp-0x18]` | `dst` | 8바이트 |
| `[rbp-0x1c]` | `value` | 4바이트 |
| `[rbp-0x28]` | `count` | 8바이트 |

### `p = dst`

```asm
mov rax, QWORD PTR [rbp-0x18]    ; rax = dst
mov QWORD PTR [rbp-0x8], rax     ; p = dst
```

### `i = 0`

```asm
mov QWORD PTR [rbp-0x10], 0x0
```

---

## 7. 반복문 분석

원본 C 반복문은 다음과 같다.

```c
for (unsigned long i = 0; i < count; i++) {
    *(p + i) = (unsigned char)value;
}
```

### 목적지 주소 계산

```asm
mov rdx, QWORD PTR [rbp-0x8]     ; rdx = p
mov rax, QWORD PTR [rbp-0x10]    ; rax = i
add rax, rdx                     ; rax = p + i
```

`p`가 `unsigned char *`이므로 원소 하나의 크기는 1바이트다. 따라서 별도의 곱셈 없이 주소에 `i`를 그대로 더한다.

### 한 바이트 저장

```asm
mov edx, DWORD PTR [rbp-0x1c]    ; edx = value
mov BYTE PTR [rax], dl           ; *(p + i) = value의 하위 1바이트
```

- `rax`: 값을 기록할 메모리 주소
- `[rax]`: 그 주소가 가리키는 메모리
- `BYTE PTR`: 메모리 1바이트만 변경
- `dl`: `edx`의 하위 8비트

이 부분이 다음 C 코드의 형 변환과 대응한다.

```c
(unsigned char)value
```

### 반복 변수 증가

```asm
add QWORD PTR [rbp-0x10], 0x1    ; i++
```

### 반복 조건 검사

```asm
mov rax, QWORD PTR [rbp-0x10]    ; rax = i
cmp rax, QWORD PTR [rbp-0x28]    ; i와 count 비교
jb  40117b                       ; unsigned i < count이면 반복
```

`jb`는 unsigned 비교에서 사용하는 `jump if below`다.  
`i`와 `count`가 `unsigned long`이므로 signed 비교 명령인 `jl`이 아니라 `jb`가 사용됐다.

---

## 8. 반환 과정

```asm
mov rax, QWORD PTR [rbp-0x18]    ; 반환값 = dst
pop rbp                          ; 호출자의 rbp 복원
ret                              ; 반환 주소를 RIP로 가져와 호출자로 복귀
```

x86-64에서 함수 반환값은 `rax`에 저장된다.

---

## 9. 포인터에서 구분해야 할 두 가지 크기

```c
unsigned char *p;
```

여기에는 서로 다른 두 크기가 존재한다.

- `p` 자체: 주소를 저장하므로 x86-64에서 8바이트
- `*p`: `unsigned char` 데이터이므로 1바이트

따라서 포인터를 스택에 저장할 때는 다음과 같이 8바이트를 사용한다.

```asm
mov QWORD PTR [rbp-0x8], rax
```

포인터가 가리키는 데이터를 변경할 때는 1바이트를 사용한다.

```asm
mov BYTE PTR [rax], dl
```

정리하면 다음과 같다.

> 포인터 자체의 크기는 주소 체계가 결정하고, 역참조 크기와 포인터 이동 간격은 포인터가 가리키는 자료형이 결정한다.

---

## 10. 기타 명령어

```asm
endbr64
```

`endbr64`는 C 코드의 `my_memset` 동작과 직접 관련된 명령이 아니다. Intel CET의 간접 분기 보호 기능을 위해 삽입된 명령이므로 이번 분석에서는 제외했다.

---

## 11. 이번 분석에서 배운 점

- x86-64 포인터는 가리키는 자료형과 관계없이 8바이트다.
- `unsigned char *`를 역참조하면 1바이트를 읽거나 쓴다.
- `dl`은 `edx`의 하위 8비트다.
- `BYTE PTR`, `DWORD PTR`, `QWORD PTR`로 메모리 접근 크기를 파악할 수 있다.
- unsigned 비교에는 `jb`, signed 비교에는 주로 `jl`이 사용된다.
- `-O0`에서는 C의 지역변수와 반복문 구조가 어셈블리에 비교적 명확하게 남는다.
- 함수의 반환값은 `rax`를 통해 전달된다.