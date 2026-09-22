# Week 1 — Lab 1: 주소·자료형·엔디언

## 1. 자료형과 크기

char = 1 byte
short = 2bytes
int = 4bytes
pointer = 8bytes (x86-64)

핵심:

- 변수의 크기를 결정하는 것은 자료형이다.
- 포인터 자체의 크기와 pointee의 크기는 별개다.

## 2. 값 / 주소 / 역참조

int *p = &arr[1];

p  = int* (arr의 첫번째 원소 주소.)
&p = int** (포인터 자체의 주소)
*p = arr[1] (p가 가리키는 arr의 첫번째 원소 값)

각각의 의미:

## 3. 포인터 산술

p + n의 실제 주소 이동량 = p + n*4bytes

예:
int *p에서 p + 2 → p + 0x8

## 4. 배열과 포인터

int arr[3];

arr의 원래 타입 = int[3]
&arr[0]의 타입 = int*
&arr의 타입 = int(*)[3]

arr + 1 = arr + 0x4
&arr + 1 = arr + 0xc

핵심:
배열과 포인터의 관계를 내 말로 설명:

## 5. Array-to-pointer conversion

conversion이 일어나는 경우: 

<aside>
💡

배열은 대부분의 표현식에서 첫번째 원소를 가리키는 pointer로 변환된다.

</aside>

arr, arr+1, p = arr, **arr, arrn)

## conversion이 일어나지 않는 대표적인 경우:

- &, sizeof() 등과 같은 곳에서 일어나지 않는다.

## 6. Little-endian

int c = 0x44556677;

낮은 주소 → 높은 주소:
[  ][  ][  ][  ]

LSB = 77
MSB = 44

little-endian의 의미를 내 말로 설명:

<aside>
💡

다바이트 값에서 LSB를 가장 낮은 메모리 주소에 배치하는 방식

</aside>

## 7. GDB

x/4bx &c 에서

x = examine
4 = 4개 출력
b = byte 단위로
x = hexadecimal
&c = 변수 c의 메모리 주소가 가리키는 곳을 참조

## 8. 내가 헷갈렸던 것

1. &arr[0] vs &arr
2. arr, &arr[0], &arr는 같은 시작 주소를 가질 수 있지만 **타입**과 +1 이동량이 다르다.
3. decimal ↔ hexadecimal 주소 계산 실수.
4. sizeof(pointer)와 sizeof(pointee), 그리고 포인터 +1의 이동 단위를 혼동했다.

## 9. 한 문장 핵심

오늘 배운 내용을 딱 한 문장으로:

pointer의 산술이동연산은 sizeof(pointee)에 의해 정해지며, arr가 array to pointer Conversion되는 상황은 다음과 같이 arr+1 될때이며 이때 arr를 객체 배열의 0번째 원소를 가리키는 int* 포인터로 간주해야 한다. 하지만 예외적으로 &arr, sizeof(arr)와 같이 conversion이 일어나지 않는 경우에는 arr 를 배열 객체 자체로 간주해야한다.

```markdown
# Week 1 — Lab 2: 같은 주소를 다른 포인터 타입으로 해석하기

## 1. 실습 코드

```c
unsigned int value = 0x12345678;
unsigned char *cp = (unsigned char *)&value;
```

## 2. 실습 전 예측

- `cp`의 값: &value (==0x1000 가정)
- `*cp`의 값: 0x78
- `cp + 1`: 0x1001
- `sizeof(*cp)`: 1 byte

## 3. 핵심 개념

### Pointer와 Pointee

내 말로 설명:
pointer는 어떤 객체의 주소를 값으로 가지는 객체로, 그 객체를 pointee라고 한다.

pointer는 주소를 값으로 저장하는 객체다. pointer가 가리키는 대상의 타입을 pointee type이라고 한다. pointee type은 역참조 시 읽는 크기와 pointer 산술의 이동단위를 결정

### 같은 주소, 다른 타입

메모리:

`[78][56][34][12]`

| 포인터 타입 | `*p`로 읽는 크기 | `p+1` 이동량 | 첫 역참조 값 |
| --- | --- | --- | --- |
| `unsigned char *` | 1 byte | 1 byte | 0x78 |
| `unsigned short *`  | 2 bytes | 2 bytes | 0x5678 |
| `unsigned int *` | 4bytes | 4bytes | 0x12345678 |

## 4. GDB 검증

사용한 명령:

p (C expression)
p/x 값

x/bx 주소

## 5. 시행착오

### `x/2bx *cp`가 실패한 이유

내 설명: x는 examine으로, 주소0x78에 있는 값을 참조하려고 할때 유효한 주소가 아니므로 오류가 난다.

### 새로 발견한 혼동

- x 명령어는 주소를 examine한다
- 

## 6. 한 문장 핵심

<aside>
💡

같은 주소라도 pointer type이 다르면 메모리를 다르게 해석할 수 있다.

</aside>