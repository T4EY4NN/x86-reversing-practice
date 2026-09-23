# Week 1 Session Review

## 1. Assembly에서 C 타입 정보
- `add rax, 0x4`만 보고 알 수 있는 것:
$rax 에 0x4만큼 더해진다.
- 원래 C pointee type을 확정할 수 있는가?:
확정할 수는 없다.
- `WORD PTR`가 의미하는 것:
해당 memory operand를 2 bytes 폭으로 접근한다.
## 2. Partial Registers
- RAX: 64bits
- EAX: rax의 하위 32bits
- AX: eax의 하위 16bits
- AL: ax의 하위 8bits

### 중요한 규칙
- EAX에 값을 쓰면: rax의 상위 32bytes는 0으로 초기화
- AX에 값을 쓰면: 상위 bits 유지
- AL에 값을 쓰면: 상위 bits 유지

## 3. Signed / Unsigned와 Two's Complement
- signed 8-bit 범위: -128 ~ 127
- unsigned 8-bit 범위: 0 ~ 255
- MSB의 의미: 최상위 비트로, signed에서 부호로 활용함.
- 음수의 2의 보수 표현을 만드는 방법: 비트를 반전시키고 +1

예:
`1111 1100`을 signed 8-bit로 해석하면: -4

## 4. movzx / movsx
### movzx
-MOVZX (Move with Zero-Extend)
작은 크기의 source operand를 읽어서 더 큰 destination operand로 복사하면서, 새로 생기는 상위 비트들을 모두 0으로 채운다.
- 예: movsx eax, BYTE PTR [rax] ([80])
0x80 = signed 8-bit -128

sign extension
→ EAX = 0xFFFFFF80
→ RAX = 0x00000000FFFFFF80

여기서 EAX write가 RAX 상위 32-bit를 0으로 만든다까지 연결.

### movsx
- 의미: 크기가 다른 operand로 음수를 복사 시에 나머지 안 맞는 공간을 1로 채운다.
- 예: movsx rax, BYTE PTR [rax]
RAX = 0xFFFFFFFFFFFFFF80

### 주의
`movsx eax, BYTE PTR [rax]`와
`movsx rax, BYTE PTR [rax]`의 차이:
rax의 첫번째 byte 값을 eax에 넣고 남은 바이트자리를 FF로 채운다. 이때 rax의 상위 32bytes는 00으로 채움.
작은 signed 값을 더 큰 크기로 확장하면서 sign bit를 복제하여 원래 signed 값을 유지한다.

## 5. 오늘 반복해서 틀린 부분

- address와 `[address]`:
  address는 주소값 자체이고, `[address]`는 그 주소가 가리키는
  메모리의 내용을 의미한다.

- register 전체 write와 partial write:
  EAX에 값을 쓰면 RAX의 상위 32 bits는 0으로 초기화된다.
  AX나 AL에 값을 쓰면 나머지 상위 bits는 유지된다.

- endian과 register representation:
  Endianness는 multi-byte 값이 메모리 주소에 배치되는 byte 순서에 관한 것이다.
  레지스터 값을 `0x...`로 표현할 때는 byte 순서를 뒤집지 않는다.

## 6. Stack+x86 Preview

- stack이 자라는 방향:
  낮은 메모리 주소 방향으로 확장된다.

- `sub rsp, 0x20`의 의미:
  RSP를 낮은 주소 방향으로 32 bytes 이동시켜
  현재 함수가 사용할 stack 공간 32 bytes를 확보한다.