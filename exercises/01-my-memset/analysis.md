# my_memset 분석 기록

## C 구현 과정

### 최초 구현

- 1. 반복 변수 `i`를 `int`로 선언했다.
- 2. `value`를 별도 형 변환 없이 저장했다.

### 수정 사항

- 1. `i`를 `unsigned long`으로 변경했다.
  - `count`와 같은 자료형으로 비교하기 위해서다.
- 2. `value`를 `unsigned char`로 변환했다.
  - `memset`은 값의 하위 1바이트만 저장하기 때문이다.
- 컴파일 옵션으로 `-Wall -Wextra`를 사용했다.

## 컴파일

```bash
gcc -Wall -Wextra -g -O0 -o my_memset_O0 source.c