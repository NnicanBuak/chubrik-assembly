; что-то не работает, не выводит на экран
  ld b, addressdisplaypointer

initgeneraterandom:
  ld a, randombytepointer
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

  mov a, 0 ; обнуление регистра
  mov c, a ; обнуление регистра
  mov d, a ; обнуление регистра

display:
  ldi a, 0x80 ; режим ввода
  st a, 0xBF ; подключение к дисплею

  ld b, addressdisplaypointer ; сброс индекса RAM
  ldi a, 0xCF

  jmp initupdatedisplay

updatedisplay:
  add b, a
initupdatedisplay:
  ld d, b ; ram(b) -> d
  st c, b ; c (0) -> ram(b)
  st d, b ; d -> ram(b) (обновляет дисплей)
  inc b
  sub b, a
  jnz updatedisplay

  hlt ; завершаем программу

constiterationnumber db 16
iterationpointer db 0
randombytepointer db 0x08
addressdisplaypointer db 0xC0