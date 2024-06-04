; Копирование значений из одного массива в другой
  ld a, sourcearray  ; загрузим адрес исходного массива в регистр A
  ld b, destinationarray    ; загрузим адрес целевого массива в регистр B
  ld c, sourcearray_length       ; загрузим длину массива в регистр C

copyLoop:
  ld d, a            ; загрузим значение из текущей ячейки исходного массива в регистр D
  st d, b            ; сохраним значение из регистра D в текущей ячейке целевого массива
  inc a              ; перейдем к следующей ячейке исходного массива
  inc b              ; перейдем к следующей ячейке целевого массива
  dec c              ; уменьшим счетчик длины массива
  jnz copyLoop       ; если длина не стала равной нулю, продолжим цикл
                     ; Теперь значения скопированы из sourcearray в destinationarray

  hlt

  sourcearray db 1, 2, 3, 4, 5        ; исходный массив
  sourcearray_length equ $ - sourcearray          ; длина массива (текущий адресс минус адресс указателя массива)
  destinationarray db 0, 0, 0, 0, 0   ; целевой массив (должен быть такой же длины)