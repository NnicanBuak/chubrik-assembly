; Программа деления с выводом на дисплей

  ldi a, 0x80          ; выбор режима для вывода
  st a, 0xBF           ; подключение дисплея

start:
  ; Ввод чисел
  ld d, divisible
  ld c, divider

  ; Ввывод входных данных на пиксельный дисплей
  st d, 0xC0

  ; Вывод графики на пиксельный дисплей
  ldi a, 0b00000000
  st a, 0xC2
  ldi a, 0b00011101
  st a, 0xC4
  ldi a, 0b00010101
  st a, 0xC6
  ldi a, 0b01111101
  st a, 0xC8
  ldi a, 0b01011101
  st a, 0xCA
  ldi a, 0b01111010
  st a, 0xCC
  ldi a, 0b00000000
  st a, 0xCE

  ; Ввывод входных данных на пиксельный дисплей
  st c, 0xD0

  ; Проверка деления на ноль
  mov a, b
  xor c, a
  jz division_error

  ; Инициализация указателя полоски процесса
  ldi b, process_bar
  ld a, b
  st a, 0xC3

  mov a, c

division_loop:
  sub a, d
  jc division_done

  ; Увеличение частного
  ld a, division_result
  inc a
  st a, division_result

  ; Отображение процесса вычислений на пиксельном дисплее
  inc b
  ld c, b
  st c, 0xC3

  ; Переход в начало цикла деления
  jmp division_loop


division_done:
  ldi b, 0b00000000
  st b, 0xC3

  ; Результат (частное)
  ; Вывод результата на пиксельный дисплей
  ld a, division_result
  st a, 0xC1

  ; Остановка программы
  hlt

division_error:
  ldi c, 0xC0          ; Инициализация указателя дисплея
  ldi d, error_message ; Инициализация как указателя изображения
display_error_loop:
  ld a, d              ; Обновление значения по указателю изображения
  st a, c              ; Запись значения изображения по указателю дисплея
  inc c
  inc d
  ldi a, error_message_length
  sub a, d
  jnz display_error_loop

  ; Остановка программы
  hlt

divisible db 8
divider db 1
division_result db 0
process_bar db 0b10000000, 0b01000000,
                0b00100000, 0b00010000,
                0b00001000, 0b00000100,
                0b00000010, 0b00000001
process_bar_length equ $ - process_bar
error_message db 0b11100000, 0b00000000,
                 0b10000000, 0b00000000,
                 0b11111111, 0b11111110,
                 0b10010010, 0b01011000,
                 0b11110010, 0b01111000,
                 0b00111010, 0b10010100,
                 0b00101010, 0b10010100,
                 0b11111010, 0b11111100,
                 0b10111010, 0b10100100,
                 0b11110100, 0b11111100,
                 0b11111111, 0b11110000,
                 0b00110110, 0b01010000,
                 0b01011110, 0b01010000,
                 0b10010010, 0b01010000,
                 0b11111110, 0b01110000
error_message_length equ $ - error_message