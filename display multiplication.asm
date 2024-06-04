  ldi a, 0x80
  st a, 0xBF
  ldi b, 4 ; первый множитель
  ldi c, 4 ; второй множитель
multiplication:
  mov a, b
  sub a, c
  mov a, 0
  jns multiplication_loop_more
  jmp multiplication_loop_less

multiplication_loop_more:
  add a, b
  mov d, a
  ld a, high_byte
  adc a, 0
  st a, high_byte
  mov a, d
  dec c
  jnz multiplication_loop_more

  ; выход из цикла
  jmp display

multiplication_loop_less:
  add a, c
  mov d, a
  ld a, high_byte
  adc a, 0
  st a, high_byte
  mov a, d
  dec b
  jnz multiplication_loop_less

  ; выход из цикла
  jmp display

display:
  st a, 0xC1
  ld d, high_byte
  st d, 0xC0
  hlt

high_byte db 0