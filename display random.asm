  ldi a, 0x80 ; режим ввода
  st a, 0xBF ; подключение к дисплею

  ldi b, addressdisplaypointer

initgeneraterandom:
  ldi a, randombytepointer
  rnd c
generaterandom:
  dec a
  jz iterationgeneraterandom
  inc b
  shl c
  jnc generaterandom
  rnd d
  st d, b
  jmp generaterandom
iterationgeneraterandom:
  ld a, iterationpointer
  ld c, constiterationnumber
  inc a
  st a, iterationpointer
  sub a, c
  jnz initgeneraterandom

  hlt ; завершение программы

iterationpointer db 0
constiterationnumber equ 4
randombytepointer equ 0x08
addressdisplaypointer equ 0xC0