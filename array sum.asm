  ldi c, sourcearray        ; Инициализация указателя
  st c, sourcearray_pointer ; Запись указателя
  ldi d, sourcearray_length ; Инициализация длины массива
  mov a, c
  add d, a                  ; Инициализация указателя конца массива

sum_loop:
  ld a, sum_first_byte      ; Обновление текущего байта суммы
  ld c, sourcearray_pointer ; Обновление указателя
  ld b, c                   ; Обновление значения массива

  add a, b                  ; Прибавление значения из массива к сумме
  st a, sum_first_byte      ; Запись текущего значения суммы
  jo sum_overflow
sum_loop_after_overflow:
  inc c                     ; Увеличение указателя
  st c, sourcearray_pointer ; Запись
  mov a, d
  sub a, c
  jnz sum_loop
  hlt

sum_overflow:
  ld b, sum_bytes_overflow
  inc b
  st b, sum_bytes_overflow
  jmp sum_loop_after_overflow

sum_first_byte db 0
sum_bytes_overflow db 0
sourcearray_pointer db 0
sourcearray db 1, 2, 3, 5, 8, 13, 21, 34, 47, 81, 128
sourcearray_length equ $ - sourcearray ; equ - это константа, а не указатель на память