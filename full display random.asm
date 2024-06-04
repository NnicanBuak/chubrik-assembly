  ldi a, 0x80
  st a, 0xBF
  ldi c, 0xC0
  ldi d, 0x20
loop:
  rnd a
  st a, c
  inc c
  dec d
  jnz loop
hlt