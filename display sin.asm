  ; Подключаем дисплей
  ldi a, 0x80
  st a, 0xBF

  jmp start

function:
  ; ld a, graph_x_pointer
  ; add a, 0 ; Обновление флагов
  ; jz display_y_axis

  ld a, graph_x_pointer
  ldi b, graph_x_loop_limit

  ; Отключаем дисплей
  ldi c, 0x00
  st c, 0xBF

  inc a
  sub b, a
  jnz function_loop
  mov a, 0

start:
function_loop:
  ld a, graph_x_pointer

  ; Нормализация x (x/8)
  shr a
  shr a
  shr a

  ; Возведение x в 3 степень
  ldi c, 3 ; не используется

  jmp powerof3
function_after_powerof3:
  mov c, a

  ; Сброс переменной перед вычислением
  mov a, 0
  st a, division_result

  ld a, powerof3_result ; Инициализация значения нормализованного X в степени 3
  ldi b, 0b00000110     ; Инициализация значения факториала трёх

  jmp division
function_after_division:
  ld a, graph_x_pointer
  ld b, division_result

  ; Нормализация x (x/8)
  shr a
  shr a
  shr a

  ; Вычисление y
  sub a, b

  ; Нормализация y (8y)
  shl a
  shl a
  shl a

  jnz function_after_y_not_0

  ld a, graph_x_pointer
  inc a
  st a, graph_x_pointer

  jmp function

function_after_y_not_0:
  mov d, a
  mov a, 0
  mov c, a

  ldi a, 9
function_calc_address_loop:

  ; a: 9 c: 0, d: number
  ; result: c
  dec a
  inc c

  sub a, d
  jnz function_calc_address_loop

  ; Приведение порядкого номера к адресу памяти дисплея
  ldi a, 0xC0
  shl c
  add a, c

  jmp graph_shift

powerof3:
  ; a: multiplicand, b: reserved, c: reserved
  ; result: a
  st a, powerof3_multiplier
powerof3_loop:
  mov b, a
  ld a, powerof3_pointer
  ldi c, 3
  sub c, a

  mov a, 0
  mov c, a

  mov a, b
  ld c, powerof3_multiplier

  jnz multiplication
  st a, powerof3_result
  jmp function_after_powerof3

multiplication:
  ; a: reserved, b: multiplicand, c: multiplier, d: reserved
  ; result_1: multiplication_result_highest_byte, result_2: multiplication_result_lowest_byte
  mov a, b
  sub a, c
  mov a, 0
  jns multiplication_loop_more
  jmp multiplication_loop_less

multiplication_loop_more:
  add a, b
  mov d, a
  ld a, multiplication_result_highest_byte
  adc a, 0
  st a, multiplication_result_highest_byte
  mov a, d
  dec c
  jnz multiplication_loop_more

  ; выход из цикла
  jmp multiplication_end

multiplication_loop_less:
  add a, c
  mov d, a
  ld a, multiplication_result_highest_byte
  adc a, 0
  st a, multiplication_result_highest_byte
  mov a, d
  dec b
  jnz multiplication_loop_less

  ; выход из цикла
  jmp multiplication_end

multiplication_end:
  st a, multiplication_result_lowest_byte

  ld b, powerof3_pointer
  inc b
  st b, powerof3_pointer

  jmp powerof3_loop

division:
  ; a: dividend, b: divider, c: 0
  ; result: division_result
  sub a, c
  jc function_after_division

  ; Увеличение частного
  ld a, division_result
  inc a
  st a, division_result

  ; Переход в начало цикла деления
  jmp division

; display_y_axis:
;   ldi a, display_start_point
;   st a, display_pointer
; display_y_axis_loop:
;   ld a, display_pointer
;   inc a
;   st a, display_pointer
;   shr a
;   jnc display_y_axis_loop

;   rcl a
;   ld b, a
;   shr b
;   jc display_y_axis_loop

;   rcl b
;   inc b
;   st b, display_pointer

graph_shift:
  ; d: display_graph_y_pointer

  ; Подключаем дисплей
  ldi a, 0x80
  st a, 0xBF

  ldi a, display_start_point
  st a, display_pointer
graph_shift_loop:
  ld b, display_pointer
  inc b
  ldi a, display_end_point
  sub a, b
  jz function
  jmp after_reserved

display_pointer db 0
display_start_point db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
display_end_point db 0

after_reserved:
  shr b
  jc graph_shift_even
  jmp graph_shift_odd

graph_shift_odd:
  rcl b
  ld a, b
  shl a

  ld c, d
  sub a, c
  jnz graph_shift_after_y_not_here
  inc c
  mov a, c
graph_shift_after_y_not_here:
  st a, b
  jmp graph_shift_loop

graph_shift_even:
  rcl b
  ld a, b
  shl a

  st a, b
  jmp graph_shift_loop

multiplication_result_highest_byte db 0
multiplication_result_lowest_byte db 0
powerof3_pointer db 0
powerof3_multiplier db 0
powerof3_result db 0
division_result db 0
graph_x_pointer db 0
graph_x_loop_limit equ 32